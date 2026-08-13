#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# run_schema_tests.py — Schema 正/负向测试运行器
#
# 对 tests/schema/data/ 下的用例：
#   *.positive.yaml 必须通过对应 schema 校验（退出 0）；
#   *.negative.yaml 必须被对应 schema 拒绝（退出非 0）。
#
# 用法：python3 tests/schema/run_schema_tests.py

import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
VALIDATOR = os.path.join(ROOT, "tools", "contract_validate", "contract_validate.py")
DATA = os.path.join(ROOT, "tests", "schema", "data")
SCHEMAS = {
    "contract": os.path.join(ROOT, "schema", "interface_contract.schema.yaml"),
    "profile": os.path.join(ROOT, "schema", "interface_profile.schema.yaml"),
    "binding": os.path.join(ROOT, "schema", "binding.schema.yaml"),
    "manifest": os.path.join(ROOT, "schema", "release_manifest.schema.yaml"),
}

# 用例文件名 -> 应使用的 schema 类别
CASES = {
    "ready_valid.positive.yaml": "contract",
    "bad_id.negative.yaml": "contract",
    "missing_required.negative.yaml": "contract",
    "bad_handshake.negative.yaml": "contract",
}


def run_case(fname, schema):
    case_path = os.path.join(DATA, fname)
    proc = subprocess.run(
        [sys.executable, VALIDATOR, "--schema", schema, "--contract", case_path],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    is_negative = ".negative." in fname
    passed = proc.returncode != 0 if is_negative else proc.returncode == 0
    return passed, proc.returncode


def main():
    failed = 0
    ran = 0
    for fname, schema_key in CASES.items():
        schema = SCHEMAS[schema_key]
        passed, rc = run_case(fname, schema)
        ran += 1
        status = "PASS" if passed else "FAIL"
        print(f"[{status}] {fname} (rc={rc})")
        if not passed:
            failed += 1

    print(f"\n{ran - failed}/{ran} schema tests passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
