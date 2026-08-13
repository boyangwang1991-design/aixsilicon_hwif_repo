#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# sv_consistency_check.py — SV 与 YAML Contract 一致性检查器
#
# 对照 Interface Contract（YAML SSOT）检查 SV interface 视图的信号一致性：
#   1. 契约中 required 的信号必须出现在 SV interface 声明中；
#   2. 契约中可选信号（capability）若 SV 未实现，给出 WARN（允许）；若实现则核对存在；
#   3. SV 中出现的非时钟/复位信号若不在契约中，给出 WARN（可能冗余或命名不一致）。
#
# 用法：
#   python3 tools/sv_consistency_check/sv_consistency_check.py \
#       --contract bus/axi/contract/axi.interface.yaml --rtl bus/axi/rtl/aix_axi_if.sv
#   python3 tools/sv_consistency_check/sv_consistency_check.py --all

import argparse
import os
import re
import sys

try:
    import yaml
    HAVE_YAML = True
except ImportError:  # pragma: no cover
    HAVE_YAML = False

EXIT_OK = 0
EXIT_FAIL = 1

# 时钟/复位等系统信号，不参与契约信号比对
SYSTEM_SIGNALS = {"clk", "rst_n", "rst_ni", "clk_i"}

# SV 信号声明：可选方向 + logic [<width>] name（后随 ; 、, 或换行前的空格）
RE_SV_LOGIC = re.compile(
    r"\b(?:input|output|inout|var|wire)?\s*\blogic\s+"
    r"(?:\[[^\]]*\]\s+)?(?:unsigned\s+)?"
    r"([a-zA-Z_][a-zA-Z0-9_]*)\s*(?:=|;|,|\b)"
)


def load_contract(path):
    if not HAVE_YAML:
        sys.stderr.write("[ERROR] pyyaml is required\n")
        return None
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def extract_contract_signals(contract):
    """从契约提取 (signal_id, required, capability, width) 列表。"""
    signals = []
    for ch in contract.get("channels", []) or []:
        for sig in ch.get("signals", []) or []:
            signals.append({
                "id": sig["id"],
                "required": sig.get("required", True),
                "capability": sig.get("capability"),
                "width": sig.get("width", "1"),
            })
    return signals


def extract_sv_signals(path):
    """扫描 SV 文件，提取声明的信号名。"""
    names = set()
    with open(path, "r", encoding="utf-8") as fh:
        content = fh.read()
    # 跳过注释（简单处理 // 与 /* */）
    content = re.sub(r"/\*.*?\*/", "", content, flags=re.S)
    content = re.sub(r"//[^\n]*", "", content)
    for m in RE_SV_LOGIC.finditer(content):
        name = m.group(1)
        if name not in SYSTEM_SIGNALS:
            names.add(name)
    return names


def check_contract_vs_sv(contract_path, sv_path):
    errors = []
    warnings = []

    contract = load_contract(contract_path)
    if contract is None:
        return [f"{contract_path}: failed to load YAML"], []

    iface = contract.get("interface", {})
    iface_name = iface.get("name", "?")
    views = contract.get("views", {})

    # 契约明确不提供 SV interface 视图时跳过
    if views.get("sv_interface") is False:
        return [], [f"{contract_path}: sv_interface=false, skip"]

    if not os.path.exists(sv_path):
        # 契约要求 sv_interface=true 但缺少 RTL
        if views.get("sv_interface", True) is True:
            return [f"{contract_path}: sv_interface required but {sv_path} not found"], []
        return [], []

    sv_signals = extract_sv_signals(sv_path)
    if not sv_signals:
        return [f"{sv_path}: no logic signals found"], []

    contract_signals = extract_contract_signals(contract)
    required_ids = {s["id"] for s in contract_signals if s["required"]}
    optional_ids = {s["id"] for s in contract_signals if not s["required"]}

    # 1. required 信号必须存在（clk/rst_n 等系统信号由 interface 端口提供，跳过）
    for sid in sorted(required_ids):
        if sid in SYSTEM_SIGNALS:
            continue
        if sid not in sv_signals:
            errors.append(f"{iface_name}: required signal '{sid}' missing in {sv_path}")

    # 2. 可选信号未实现 -> WARN
    for sid in sorted(optional_ids):
        if sid not in sv_signals:
            warnings.append(f"{iface_name}: optional signal '{sid}' not implemented (OK if capability unused)")

    # 3. SV 中有但契约无（排除系统信号）-> WARN
    known = required_ids | optional_ids
    for name in sorted(sv_signals - known):
        warnings.append(f"{iface_name}: signal '{name}' in SV but not in contract")

    return errors, warnings


def collect_pairs(root):
    """扫描接口族目录，返回 (contract, sv) 配对。

    契约位于 <family>/contract/xxx.interface.yaml，SV 位于 <family>/rtl/。
    """
    pairs = []
    for dirpath, _dirnames, filenames in os.walk(root):
        contracts = [f for f in filenames if f.endswith(".interface.yaml")]
        if not contracts:
            continue
        # contract/ 的上一级即接口族根目录，rtl/ 与之平级
        family_dir = os.path.dirname(dirpath)
        rtl_dir = os.path.join(family_dir, "rtl")
        for c in contracts:
            sv_candidates = []
            if os.path.isdir(rtl_dir):
                sv_candidates = sorted(
                    os.path.join(rtl_dir, f)
                    for f in os.listdir(rtl_dir)
                    if f.endswith("_if.sv")
                )
            sv = sv_candidates[0] if sv_candidates else None
            pairs.append((os.path.join(dirpath, c), sv))
    return pairs


def main():
    parser = argparse.ArgumentParser(description="SV vs YAML Contract consistency checker")
    parser.add_argument("--contract", default=None, help="contract YAML path")
    parser.add_argument("--rtl", default=None, help="SV interface file path")
    parser.add_argument("--all", action="store_true", help="scan all interface families in repo")
    parser.add_argument("--root", default=".", help="root dir for --all scan")
    args = parser.parse_args()

    if args.all:
        pairs = collect_pairs(args.root)
        if not pairs:
            sys.stderr.write("[WARN] no interface families found under %s\n" % args.root)
            return EXIT_OK
    elif args.contract and args.rtl:
        pairs = [(args.contract, args.rtl)]
    else:
        parser.error("provide --contract/--rtl or --all")

    total_errors = 0
    total_warnings = 0
    for contract_path, sv_path in pairs:
        if sv_path is None:
            # 契约存在但无 *_if.sv
            errors, warnings = check_contract_vs_sv(contract_path, os.path.join(os.path.dirname(contract_path), "rtl", "missing.sv"))
            # 修正：无 sv 时直接报错（sv_interface=true）
            warnings = [w for w in warnings if not w.startswith("missing")]
            if errors:
                total_errors += len(errors)
                for e in errors:
                    sys.stderr.write("[FAIL] %s\n" % e)
            continue
        errors, warnings = check_contract_vs_sv(contract_path, sv_path)
        if errors:
            total_errors += len(errors)
            for e in errors:
                sys.stderr.write("[FAIL] %s\n" % e)
        else:
            sys.stdout.write("[PASS] %s <-> %s\n" % (os.path.relpath(contract_path), os.path.relpath(sv_path)))
        for w in warnings:
            total_warnings += 1
            sys.stdout.write("[WARN] %s\n" % w)

    if total_errors:
        sys.stderr.write("FAILED: %d error(s), %d warning(s)\n" % (total_errors, total_warnings))
        return EXIT_FAIL
    sys.stdout.write("OK: SV consistency check passed (%d warning(s))\n" % total_warnings)
    return EXIT_OK


if __name__ == "__main__":
    sys.exit(main())
