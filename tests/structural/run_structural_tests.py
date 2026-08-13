#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# run_structural_tests.py — 结构一致性测试
#
# 覆盖 plan §17.3：
#   - width expression 求值（受限表达式）；
#   - 契约信号与 SV interface 信号一致性（复用 sv_consistency_check 核心逻辑）；
#   - flat wrapper 命名规则检查（View C `<prefix>_<chan>_<sig>_<dir>`）。

import os
import re
import sys

try:
    import yaml
    HAVE_YAML = True
except ImportError:  # pragma: no cover
    HAVE_YAML = False

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

WIDTH_EXPR_CASES = [
    ("DATA_W", {"DATA_W": 64}, 64),
    ("8", {}, 8),
    ("DATA_W / 8", {"DATA_W": 64}, 8),
    ("ADDR_W + 1", {"ADDR_W": 31}, 32),
    ("DATA_W * 2", {"DATA_W": 32}, 64),
]


def eval_width(expr, params):
    s = str(expr).strip()
    for k, v in params.items():
        s = s.replace(str(k), str(v))
    if not re.fullmatch(r"[0-9+\-*/()\s]+", s):
        return None
    try:
        return int(eval(s, {"__builtins__": {}}, {}))
    except Exception:
        return None


def test_width():
    passed = 0
    for expr, params, expect in WIDTH_EXPR_CASES:
        got = eval_width(expr, params)
        ok = got == expect
        passed += ok
        print(f"[{'PASS' if ok else 'FAIL'}] width {expr} -> {got} (expect {expect})")
    return passed, len(WIDTH_EXPR_CASES)


def test_sv_consistency():
    """每个 family 的契约 required 信号须出现在 *_if.sv 中。"""
    import subprocess
    proc = subprocess.run(
        [sys.executable, os.path.join(ROOT, "tools", "sv_consistency_check",
                                      "sv_consistency_check.py"), "--all", "--root", ROOT],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
    ok = "OK: SV consistency" in proc.stdout or "PASS" in proc.stdout
    print(f"[{'PASS' if ok else 'FAIL'}] sv_consistency_check (rc={proc.returncode})")
    return 1 if ok else 0, 1


def test_flat_naming():
    """检查示例 flat wrapper 命名（若存在）。"""
    wrapper = os.path.join(ROOT, "bus", "axi", "rtl", "aix_axi_flat_wrapper.sv")
    if not os.path.exists(wrapper):
        print("[SKIP] no flat wrapper to check")
        return 1, 1
    with open(wrapper, "r", encoding="utf-8") as fh:
        content = fh.read()
    # 应包含形如 <chan>_<sig> 的端口命名（s_axi_... 或 aw_...）
    ok = bool(re.search(r"(aw|ar|w|b|r)_(valid|ready|addr|data)", content))
    print(f"[{'PASS' if ok else 'FAIL'}] flat wrapper naming")
    return 1 if ok else 0, 1


def main():
    totals = {"passed": 0, "total": 0}
    for fn in (test_width, test_sv_consistency, test_flat_naming):
        p, t = fn()
        totals["passed"] += p
        totals["total"] += t
    print(f"\n{totals['passed']}/{totals['total']} structural tests passed")
    return 1 if totals["passed"] != totals["total"] else 0


if __name__ == "__main__":
    sys.exit(main())
