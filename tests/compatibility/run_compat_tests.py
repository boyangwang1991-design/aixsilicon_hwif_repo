#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# run_compat_tests.py — Compatibility Checker 单元测试
# 验证三类结论（DIRECT / ADAPTER_REQUIRED / INCOMPATIBLE），对应 plan §13.3。

import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CHECKER = os.path.join(ROOT, "tools", "compatibility_check", "compatibility_check.py")

AXI = os.path.join(ROOT, "bus", "axi", "contract", "axi.interface.yaml")
APB = os.path.join(ROOT, "bus", "apb", "contract", "apb.interface.yaml")
AXI_MEM_PROFILE = os.path.join(ROOT, "bus", "axi", "contract", "axi_memory_basic_v1.profile.yaml")
AXI_DMA_PROFILE = os.path.join(ROOT, "bus", "axi", "contract", "axi_dma_high_bw_v1.profile.yaml")

CASES = [
    {
        "name": "AXI same width -> DIRECT",
        "args": [AXI, AXI, '{"DATA_W": 64}', '{"DATA_W": 64}'],
        "expect": "DIRECT",
    },
    {
        "name": "AXI width mismatch -> ADAPTER_REQUIRED",
        "args": [AXI, AXI, '{"DATA_W": 128}', '{"DATA_W": 32}'],
        "expect": "ADAPTER_REQUIRED",
    },
    {
        "name": "AXI vs APB -> INCOMPATIBLE",
        "args": [AXI, APB, None, None],
        "expect": "INCOMPATIBLE",
    },
    {
        "name": "AXI memory_basic vs dma_high_bw profiles -> DIRECT",
        "args": [AXI, AXI, None, None],
        "expect": "DIRECT",
        "sprofile": AXI_MEM_PROFILE,
        "tprofile": AXI_DMA_PROFILE,
    },
]


def run_case(c):
    cmd = [sys.executable, CHECKER, "--source", c["args"][0], "--target", c["args"][1]]
    if c["args"][2]:
        cmd += ["--source-params", c["args"][2]]
    if c["args"][3]:
        cmd += ["--target-params", c["args"][3]]
    if c.get("sprofile"):
        cmd += ["--source-profile", c["sprofile"]]
    if c.get("tprofile"):
        cmd += ["--target-profile", c["tprofile"]]
    proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                          universal_newlines=True)
    result_line = [l for l in proc.stdout.splitlines() if l.startswith("result")]
    result = result_line[0].split(":", 1)[1].strip() if result_line else "?"
    passed = result == c["expect"]
    print(f"[{'PASS' if passed else 'FAIL'}] {c['name']} (got {result}, expect {c['expect']})")
    return passed


def main():
    failed = sum(1 for c in CASES if not run_case(c))
    print(f"\n{len(CASES) - failed}/{len(CASES)} compatibility tests passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
