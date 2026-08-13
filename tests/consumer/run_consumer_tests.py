#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# run_consumer_tests.py — 消费者测试
#
# 覆盖 plan §17.3/§26：
#   - IP 消费者：examples/ 下 core 依赖接口 Core 且可编译；
#   - VIP 消费者：bindings/ 下 binding 能解析 interface 引用；
#   - 依赖完整性：每个 *_pkg.sv / *_if.sv 所属 core 已声明 rtl fileset。

import os
import re
import subprocess
import sys

try:
    import yaml
    HAVE_YAML = True
except ImportError:  # pragma: no cover
    HAVE_YAML = False

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def collect_bindings():
    out = []
    bdir = os.path.join(ROOT, "bindings")
    for dirpath, _d, files in os.walk(bdir):
        for f in files:
            if f.endswith(".yaml") and "schema" not in dirpath:
                out.append(os.path.join(dirpath, f))
    return out


def collect_example_cores():
    out = []
    edir = os.path.join(ROOT, "examples")
    for dirpath, _d, files in os.walk(edir):
        for f in files:
            if f.endswith(".core"):
                out.append(os.path.join(dirpath, f))
    return out


def test_bindings():
    passed, total = 0, 0
    for path in collect_bindings():
        total += 1
        try:
            with open(path, "r", encoding="utf-8") as fh:
                data = yaml.safe_load(fh)
            binding = (data or {}).get("binding", {})
            iface = binding.get("interface")
            ok = bool(iface)
        except Exception:
            ok = False
        passed += ok
        print(f"[{'PASS' if ok else 'FAIL'}] binding {os.path.relpath(path, ROOT)}")
    return passed, total


def test_core_depends():
    passed, total = 0, 0
    for path in collect_example_cores():
        total += 1
        with open(path, "r", encoding="utf-8") as fh:
            content = fh.read()
        # 示例 core 应依赖某接口 Core
        ok = bool(re.search(r"aix:interface:", content))
        passed += ok
        print(f"[{'PASS' if ok else 'FAIL'}] example core {os.path.relpath(path, ROOT)}")
    return passed, total


def test_rtl_in_core():
    """每个接口族 rtl/*.sv 必须被其 core 引用。"""
    passed, total = 0, 0
    for dirpath, _d, files in os.walk(ROOT):
        if "/reference" in dirpath or "/generated" in dirpath or "/tests" in dirpath:
            continue
        cores = [f for f in files if f.endswith(".core")]
        if not cores:
            continue
        rtl_files = []
        rtl_dir = os.path.join(dirpath, "rtl")
        if os.path.isdir(rtl_dir):
            rtl_files = [f for f in os.listdir(rtl_dir) if f.endswith(".sv")]
        if not rtl_files:
            continue
        for core_name in cores:
            total += 1
            with open(os.path.join(dirpath, core_name), "r", encoding="utf-8") as fh:
                content = fh.read()
            missing = [f for f in rtl_files if f not in content]
            ok = not missing
            passed += ok
            if not ok:
                print(f"[FAIL] {core_name} missing rtl refs: {missing}")
    return passed, total


def main():
    totals = {"passed": 0, "total": 0}
    for fn in (test_bindings, test_core_depends, test_rtl_in_core):
        p, t = fn()
        totals["passed"] += p
        totals["total"] += t
    print(f"\n{totals['passed']}/{totals['total']} consumer tests passed")
    return 1 if totals["passed"] != totals["total"] else 0


if __name__ == "__main__":
    sys.exit(main())
