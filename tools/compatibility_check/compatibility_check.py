#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# compatibility_check.py — 接口兼容性判定器
#
# 根据三层兼容性模型输出唯一三类结论：DIRECT / ADAPTER_REQUIRED / INCOMPATIBLE。
#   1. Protocol Compatibility：同一接口族 + 兼容规范版本；
#   2. Profile Compatibility：必选能力匹配、参数（宽度等）匹配；
#   3. Binding Compatibility：角色与信号匹配（骨架级）。
#
# 用法：
#   python3 tools/compatibility_check/compatibility_check.py \
#       --source bus/axi/contract/axi.interface.yaml \
#       --target bus/axi/contract/axi.interface.yaml \
#       [--source-params '{"DATA_W": 64}'] [--target-params '{"DATA_W": 32}']
#
# 说明：本工具为骨架级判定器。ADAPTER_REQUIRED/INCOMPATIBLE 的具体适配与拒绝
# 策略应结合 Catalog 中已认证 CBB Adapter（plan §13、§15.3）。

import argparse
import json
import os
import sys

try:
    import yaml
    HAVE_YAML = True
except ImportError:  # pragma: no cover
    HAVE_YAML = False

DIRECT = "DIRECT"
ADAPTER_REQUIRED = "ADAPTER_REQUIRED"
INCOMPATIBLE = "INCOMPATIBLE"


def load_contract(path):
    if not HAVE_YAML:
        sys.stderr.write("[ERROR] pyyaml is required\n")
        return None
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def eval_width(expr, params):
    """受限宽度表达式求值：仅支持 数字 / 参数名 / N / 8 等简单算术。"""
    import re
    s = str(expr).strip()
    # 替换参数名
    for k, v in params.items():
        s = s.replace(str(k), str(v))
    # 仅允许数字、空格、+ - * / ( )
    if not re.fullmatch(r"[0-9+\-*/()\s]+", s):
        return None
    try:
        return int(eval(s, {"__builtins__": {}}, {}))
    except Exception:
        return None


def param_values(contract, override):
    params = {}
    for p in contract.get("parameters", []) or []:
        params[p["id"]] = p.get("default", 0)
    if override:
        params.update(override)
    return params


def required_capabilities(contract):
    """收集契约 signals 中 capability 且 required=false 的能力 ID（可选项）。"""
    caps = set()
    for ch in contract.get("channels", []) or []:
        for sig in ch.get("signals", []) or []:
            if sig.get("capability"):
                caps.add(sig["capability"])
    return caps


def load_profile(path):
    """加载 Profile 文件（interface_profile.schema.yaml 约束）。"""
    if path is None:
        return {}
    if not os.path.exists(path):
        sys.stderr.write(f"[WARN] profile not found: {path}\n")
        return {}
    with open(path, "r", encoding="utf-8") as fh:
        data = yaml.safe_load(fh)
    return (data or {}).get("profile", {})


def profile_capabilities(profile):
    """Profile 的能力约束：{cap_id: required/optional/forbidden}。"""
    return dict(profile.get("capabilities", {}) or {})


def check_profile_compat(s_profile, t_profile, details):
    """Profile 能力协商（plan §13.1 第二层）。

    规则：source 的 required 能力，target 不能为 forbidden；
          source 的 forbidden 能力，target 不能为 required。
    """
    if not s_profile and not t_profile:
        return True
    s_caps = profile_capabilities(s_profile)
    t_caps = profile_capabilities(t_profile)

    # source required 但 target forbidden -> INCOMPATIBLE
    for cap, state in s_caps.items():
        if state == "required" and t_caps.get(cap) == "forbidden":
            details.append(f"profile: source requires '{cap}' but target forbids it")
            return False
    # source forbidden 但 target required -> INCOMPATIBLE
    for cap, state in s_caps.items():
        if state == "forbidden" and t_caps.get(cap) == "required":
            details.append(f"profile: source forbids '{cap}' but target requires it")
            return False
    return True


def check_compat(src, tgt, sp, tp, s_profile=None, t_profile=None):
    """返回 (结论, 详情列表)。"""
    details = []

    # ---- 1. Protocol Compatibility ----
    s_iface = src.get("interface", {})
    t_iface = tgt.get("interface", {})
    if s_iface.get("family") != t_iface.get("family"):
        details.append(
            f"protocol: family mismatch ({s_iface.get('family')} vs {t_iface.get('family')})"
        )
        return INCOMPATIBLE, details

    # ---- 1.5 Profile Compatibility（能力协商）----
    if not check_profile_compat(s_profile, t_profile, details):
        return INCOMPATIBLE, details

    # ---- 2. Parameter Compatibility ----
    s_params = param_values(src, sp)
    t_params = param_values(tgt, tp)

    param_mismatch = False
    # 比较共同参数的求值宽度
    for pid in sorted(set(s_params) & set(t_params)):
        sv = s_params[pid]
        tv = t_params[pid]
        # 仅当二者都是数值时才比较（字符串/枚举不比较）
        if isinstance(sv, (int, float)) and isinstance(tv, (int, float)):
            if sv != tv:
                details.append(f"profile: parameter {pid} differs ({sv} vs {tv})")
                param_mismatch = True

    # 能力：source 有而 target 无 -> 可能不兼容或需 adapter
    s_caps = required_capabilities(src)
    t_caps = required_capabilities(tgt)
    missing = s_caps - t_caps
    if missing:
        details.append(f"profile: target lacks capabilities {sorted(missing)}")
        return ADAPTER_REQUIRED, details

    # ---- 3. Binding Compatibility ----
    s_roles = {r["id"] for r in src.get("roles", []) or []}
    t_roles = {r["id"] for r in tgt.get("roles", []) or []}
    # 至少应有交集角色（源可扮演目标角色）
    if not (s_roles & t_roles):
        details.append(
            f"binding: no common role ({sorted(s_roles)} vs {sorted(t_roles)})"
        )
        return INCOMPATIBLE, details

    if param_mismatch:
        details.append("binding: parameter mismatch -> width/ID adapter likely required")
        return ADAPTER_REQUIRED, details

    details.append("protocol/profile/binding compatible")
    return DIRECT, details


def main():
    parser = argparse.ArgumentParser(description="Interface compatibility checker")
    parser.add_argument("--source", required=True, help="source contract YAML")
    parser.add_argument("--target", required=True, help="target contract YAML")
    parser.add_argument("--source-params", default=None, help="JSON override for source params")
    parser.add_argument("--target-params", default=None, help="JSON override for target params")
    parser.add_argument("--source-profile", default=None, help="source profile YAML (optional)")
    parser.add_argument("--target-profile", default=None, help="target profile YAML (optional)")
    args = parser.parse_args()

    src = load_contract(args.source)
    tgt = load_contract(args.target)
    if src is None or tgt is None:
        return 1

    sp = json.loads(args.source_params) if args.source_params else {}
    tp = json.loads(args.target_params) if args.target_params else {}

    s_profile = load_profile(args.source_profile)
    t_profile = load_profile(args.target_profile)

    result, details = check_compat(src, tgt, sp, tp, s_profile, t_profile)

    print(f"source : {args.source}")
    print(f"target : {args.target}")
    print(f"result : {result}")
    for d in details:
        print(f"  - {d}")

    return 0 if result == DIRECT else 0  # 判定器本身不因不兼容而失败；由调用方决策


if __name__ == "__main__":
    sys.exit(main())
