#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# contract_validate.py — AIXSILICON HW Interface Contract 校验器
#
# 校验 Interface Contract / Profile / Binding / Compatibility / Release Manifest
# 是否符合 schema/ 下的 JSON Schema（YAML 表示）。
#
# 依赖（可选）：
#   pyyaml      — YAML 解析
#   jsonschema  — JSON Schema 校验
# 若依赖缺失，则退化为基础结构检查（加载 YAML + 必填字段存在性检查）。

import argparse
import fnmatch
import json
import os
import sys

# ---------------------------------------------------------------------------
# 可选依赖
# ---------------------------------------------------------------------------
try:
    import yaml
    HAVE_YAML = True
except ImportError:  # pragma: no cover
    HAVE_YAML = False

try:
    import jsonschema
    # 优先使用 2020-12（jsonschema>=4.0）；旧版本 jsonschema 3.x 仅支持到 draft-07，
    # 在此环境下回退到 Draft7Validator，避免 Python 版本受限时无法执行 schema 校验。
    try:
        from jsonschema import Draft202012Validator as _SchemaValidator
    except ImportError:  # pragma: no cover
        from jsonschema import Draft7Validator as _SchemaValidator
    HAVE_JSONSCHEMA = True
except ImportError:  # pragma: no cover
    HAVE_JSONSCHEMA = False

EXIT_OK = 0
EXIT_FAIL = 1


def load_yaml(path):
    """加载 YAML 文件；依赖缺失时报出明确提示。"""
    if not HAVE_YAML:
        sys.stderr.write(
            "[ERROR] pyyaml is required to validate YAML files.\n"
            "Install with: pip install pyyaml jsonschema\n"
        )
        return None
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def load_schema(path):
    """加载 Schema 文件（JSON 或 YAML）。"""
    data = load_yaml(path)
    if data is None:
        return None
    return data


def _basic_check(contract, path):
    """无 jsonschema 时的退化校验：必填字段存在性检查。"""
    errors = []
    if not isinstance(contract, dict):
        errors.append(f"{path}: top-level must be a mapping")
        return errors

    # contract: interface + channels + views + roles 必须存在
    if "interface" in contract and isinstance(contract["interface"], dict):
        iface = contract["interface"]
        for field in ("id", "name", "family", "semantic_version", "owner",
                      "lifecycle"):
            if field not in iface:
                errors.append(f"{path}: interface.{field} is missing")
    if "interface" in contract and "channels" not in contract:
        errors.append(f"{path}: 'channels' is missing (required for contracts)")
    if "interface" in contract and "views" not in contract:
        errors.append(f"{path}: 'views' is missing (required for contracts)")

    # profile: profile.id/interface/version/capabilities 必须存在
    if "profile" in contract:
        prof = contract["profile"]
        for field in ("id", "interface", "version", "capabilities",
                      "compatibility_class"):
            if field not in prof:
                errors.append(f"{path}: profile.{field} is missing")

    # binding: binding.interface + binding.target 必须存在
    if "binding" in contract:
        bnd = contract["binding"]
        for field in ("interface", "target"):
            if field not in bnd:
                errors.append(f"{path}: binding.{field} is missing")
    return errors


def validate_against_schema(contract, schema):
    """使用 jsonschema 校验；返回错误列表。"""
    if not HAVE_JSONSCHEMA:
        return _basic_check(contract, "<input>")
    validator = _SchemaValidator(schema)
    errors = []
    for err in sorted(validator.iter_errors(contract), key=lambda e: list(e.path)):
        errors.append(f"schema violation at {list(err.path)}: {err.message}")
    return errors


def collect_files(root, patterns):
    """递归收集匹配 patterns（如 *.interface.yaml / *.profile.yaml）的文件。"""
    matches = []
    for dirpath, _dirnames, filenames in os.walk(root):
        for fname in filenames:
            if any(fnmatch.fnmatch(fname, pat) for pat in patterns):
                matches.append(os.path.join(dirpath, fname))
    return sorted(matches)


def main():
    parser = argparse.ArgumentParser(
        description="AIXSILICON HW Interface Contract validator")
    parser.add_argument("--schema", default=None, help="path to schema YAML/JSON")
    parser.add_argument("--contract", default=None, help="path to contract YAML")
    parser.add_argument("--all", action="store_true",
                        help="validate all contracts in repository")
    parser.add_argument("--root", default=".",
                        help="root dir for --all scan (default: .)")
    args = parser.parse_args()

    targets = []
    if args.all:
        root = args.root
        patterns = ["*.interface.yaml", "*.profile.yaml", "*binding*.yaml",
                    "compatibility.yaml", "release_manifest.yaml"]
        targets = [(p, None) for p in collect_files(root, patterns)]
        if not targets:
            sys.stderr.write("[WARN] no contract files found under %s\n" % root)
            return EXIT_OK
    elif args.contract:
        targets = [(args.contract, args.schema)]
    else:
        parser.error("provide --contract <file> or --all")

    failed = 0
    for path, schema_path in targets:
        contract = load_yaml(path)
        if contract is None:
            failed += 1
            continue

        errors = []
        if schema_path:
            schema = load_schema(schema_path)
            if schema is None:
                failed += 1
                continue
            errors = validate_against_schema(contract, schema)
        else:
            # 无显式 schema 时做基础结构检查
            errors = _basic_check(contract, path)

        if errors:
            failed += 1
            for e in errors:
                sys.stderr.write("[FAIL] %s\n" % e)
        else:
            sys.stdout.write("[PASS] %s\n" % path)

    if failed:
        sys.stderr.write("FAILED: %d file(s) failed validation\n" % failed)
        return EXIT_FAIL

    sys.stdout.write("OK: all contract files passed validation\n")
    return EXIT_OK


if __name__ == "__main__":
    sys.exit(main())
