#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# run_compile_tests.py — SV 多工具编译测试
#
# 用本机可用的工具（优先 vlogan/VCS，其次 iverilog）按拓扑顺序编译全部 RTL；
# 无工具时报告 SKIP。这是 plan §17.4 多工具基线的轻量入口。

import os
import shutil
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
os.chdir(ROOT)


def file_list():
    """拓扑顺序：common -> *_pkg.sv -> interface/consumer（与 compile_smoke.sh 一致）。"""
    common = []
    for f in sorted(os.listdir(os.path.join(ROOT, "common", "rtl"))):
        if f.endswith((".sv", ".svh")):
            common.append(os.path.join("common", "rtl", f))

    pkgs, rest = [], []
    for dirpath, _d, files in os.walk(ROOT):
        rel = os.path.relpath(dirpath, ROOT)
        # 排除第三方参考、生成物、测试、common（已显式加入）与 common 子目录
        parts = rel.split(os.sep)
        if parts and parts[0] in ("reference", "generated", "tests", "common"):
            continue
        for f in files:
            if f.endswith(".sv"):
                p = os.path.join(dirpath, f)
                if f.endswith("_pkg.sv"):
                    pkgs.append(p)
                else:
                    rest.append(p)
    return common + sorted(pkgs) + sorted(rest)


def clean_artifacts():
    for d in ("AN.DB", "csrc", "work"):
        if os.path.isdir(d):
            shutil.rmtree(d, ignore_errors=True)


def main():
    files = file_list()
    print(f"[INFO] {len(files)} SV files to compile")

    if shutil.which("vlogan"):
        # -nc: 关闭增量编译缓存，避免与既有 AN.DB 冲突
        cmd = ["vlogan", "-sverilog", "-nc", "-quiet", "-timescale=1ns/1ps"] + files
        print(f"[RUN] vlogan ({len(files)} files)")
        proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        clean_artifacts()
        if proc.returncode == 0:
            print("[PASS] vlogan compile")
            return 0
        print(proc.stdout.decode(errors="replace")[-3000:])
        print("[FAIL] vlogan compile")
        return 1

    if shutil.which("iverilog"):
        cmd = ["iverilog", "-g2012", "-s", "none"] + files
        print(f"[RUN] iverilog ({len(files)} files)")
        proc = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        if proc.returncode == 0:
            print("[PASS] iverilog compile")
            return 0
        print(proc.stdout.decode(errors="replace")[-3000:])
        print("[FAIL] iverilog compile")
        return 1

    print("[SKIP] no supported compiler (vlogan/iverilog) found")
    return 0


if __name__ == "__main__":
    sys.exit(main())
