#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# impact_analysis.py — 接口变更影响分析
#
# 分析修改一个接口族后受影响的范围（IP / CBB / VIP / SoC / 依赖它的接口）。
# 依赖关系来源：
#   1. FuseSoC `.core` 的 `depend`（跨接口依赖）；
#   2. `bindings/` 下的绑定（VIP 等消费者）；
#   3. `examples/`、`tests/consumer/` 等消费示例。
#
# 用法：
#   python3 tools/impact_analysis/impact_analysis.py --family axi
#   python3 tools/impact_analysis/impact_analysis.py --all

import argparse
import os
import re
import sys

try:
    import yaml
    HAVE_YAML = True
except ImportError:  # pragma: no cover
    HAVE_YAML = False

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# .core 依赖：aix:interface:<family>:<ver>
RE_DEPEND = re.compile(r"aix:interface:([a-z0-9_]+):")


def load_core_depends():
    """扫描所有 .core 文件，返回 {core_name: [依赖的 interface family...]}"""
    result = {}
    for dirpath, _d, files in os.walk(ROOT):
        if "/reference" in dirpath or "/generated" in dirpath:
            continue
        for f in files:
            if f.endswith(".core"):
                path = os.path.join(dirpath, f)
                with open(path, "r", encoding="utf-8") as fh:
                    content = fh.read()
                depends = sorted(set(RE_DEPEND.findall(content)))
                if depends:
                    result[path] = depends
    return result


def list_families():
    """扫描所有契约的 interface.family 字段（SSOT，避免目录推断错误）。"""
    families = set()
    if not HAVE_YAML:
        return sorted(families)
    for dirpath, _d, files in os.walk(ROOT):
        if "/reference" in dirpath or "/generated" in dirpath:
            continue
        for f in files:
            if f.endswith(".interface.yaml"):
                path = os.path.join(dirpath, f)
                try:
                    with open(path, "r", encoding="utf-8") as fh:
                        data = yaml.safe_load(fh)
                    fam = (data or {}).get("interface", {}).get("family")
                    if fam:
                        families.add(fam)
                except Exception:
                    continue
    return sorted(families)


def list_consumers_for(family):
    """列出直接依赖 family 的消费者（core 文件 + bindings + examples/tests）。"""
    consumers = []

    # 1. .core depend
    core_depends = load_core_depends()
    for core_path, deps in core_depends.items():
        if family in deps:
            rel = os.path.relpath(core_path, ROOT)
            consumers.append(("core", rel))

    # 2. bindings（VIP 等消费者）
    bind_dir = os.path.join(ROOT, "bindings")
    if os.path.isdir(bind_dir):
        for dirpath, _d, files in os.walk(bind_dir):
            for f in files:
                if f.endswith(".yaml") and "schema" not in dirpath:
                    consumers.append(("binding", os.path.relpath(os.path.join(dirpath, f), ROOT)))

    # 3. examples / tests/consumer
    for sub in ("examples", os.path.join("tests", "consumer")):
        d = os.path.join(ROOT, sub)
        if os.path.isdir(d):
            for dirpath, _d, files in os.walk(d):
                for f in files:
                    if f.endswith((".core", ".sv", ".svh", ".yaml")):
                        consumers.append(
                            ("consumer", os.path.relpath(os.path.join(dirpath, f), ROOT))
                        )

    # 去重
    seen = set()
    uniq = []
    for kind, path in consumers:
        if path not in seen:
            seen.add(path)
            uniq.append((kind, path))
    return uniq


def main():
    parser = argparse.ArgumentParser(description="Interface change impact analysis")
    parser.add_argument("--family", default=None, help="interface family to analyze (e.g. axi)")
    parser.add_argument("--all", action="store_true", help="list all families with consumer counts")
    args = parser.parse_args()

    families = list_families()
    if not families:
        sys.stderr.write("[WARN] no interface families found\n")
        return 1

    if args.all:
        print(f"{'family':<20} {'consumers':>9}")
        print("-" * 32)
        for fam in families:
            cons = list_consumers_for(fam)
            print(f"{fam:<20} {len(cons):>9}")
        return 0

    if not args.family:
        parser.error("provide --family <name> or --all")

    family = args.family
    if family not in families:
        sys.stderr.write(f"[ERROR] family '{family}' not found. Known: {', '.join(families)}\n")
        return 1

    print(f"Impact analysis for interface family: {family}")
    print("=" * 60)

    # 直接依赖该族的接口（间接影响面）
    core_depends = load_core_depends()
    print("\n[1] Interface cores depending on it:")
    found = False
    for core_path, deps in core_depends.items():
        if family in deps:
            rel = os.path.relpath(core_path, ROOT)
            print(f"    {rel}  (via: {', '.join(deps)})")
            found = True
    if not found:
        print("    (none)")

    print("\n[2] Direct consumers (bindings/examples/tests):")
    consumers = list_consumers_for(family)
    for kind, path in consumers:
        print(f"    [{kind}] {path}")
    if not consumers:
        print("    (none)")

    print("\n[3] Summary:")
    print(f"    {len(consumers)} direct consumer(s); see above for details")
    return 0


if __name__ == "__main__":
    sys.exit(main())
