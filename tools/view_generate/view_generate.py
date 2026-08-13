#!/usr/bin/env python3
# Copyright (c) 2026 AIXSILICON
# SPDX-License-Identifier: Apache-2.0
#
# view_generate.py — 从 YAML Contract 确定性生成 SV interface 视图（View B）
#
# 生成内容（输出到 <out_dir>/<family>/aix_<name>_if.sv）：
#   - interface aix_<name>_if：按契约 channel/signal 生成内部 logic 与 modport；
#   - 确定性：同输入必产生相同输出（便于 hash/CI 校验生成视图为最新）。
#
# 用法：
#   python3 tools/view_generate/view_generate.py \
#       --contract foundation/ready_valid/contract/ready_valid.interface.yaml \
#       --out generated/
#   python3 tools/view_generate/view_generate.py --all --root .

import argparse
import hashlib
import os
import sys

try:
    import yaml
    HAVE_YAML = True
except ImportError:  # pragma: no cover
    HAVE_YAML = False

# 契约中由 interface 端口提供的系统信号，生成到端口而非内部声明
SYSTEM_SIGNALS = {"clk", "rst_n"}


def load_yaml(path):
    if not HAVE_YAML:
        sys.stderr.write("[ERROR] pyyaml is required\n")
        return None
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def width_to_sv(width_expr, params):
    """将契约宽度表达式映射为 SV 位宽。

    纯数字 N -> 生成 [N-1:0]；参数/表达式（如 DATA_W、DATA_W/8）原样保留，
    由 SV 参数求值（受限表达式，不允许任意脚本）。
    """
    expr = width_expr.strip()
    if expr.isdigit():
        return f"[{int(expr) - 1}:0]"
    return f"[{expr}-1:0]"


def build_port_list(contract, params):
    """收集系统信号（clk/rst_n）作为 interface 端口。"""
    ports = []
    for cd in contract.get("clock_domains", []) or []:
        ports.append(cd["id"])
    for rd in contract.get("reset_domains", []) or []:
        ports.append(rd["id"])
    return ports


def build_param_list(contract):
    """从契约 parameters 生成 SV 参数声明（未限定宽度参数的引用）。"""
    decls = []
    all_params = contract.get("parameters", []) or []
    for i, p in enumerate(all_params):
        pid = p["id"]
        ptype = p.get("type", "uint")
        default = p.get("default", 0)
        comma = "," if i < len(all_params) - 1 else ""
        # 宽度参数通常以 int unsigned 表达
        if ptype in ("uint", "int"):
            decls.append(f"  parameter int unsigned {pid} = {default}{comma}")
        elif ptype == "bool":
            decls.append(f"  parameter bit {pid} = {1 if default else 0}{comma}")
        elif ptype == "enum":
            # 语义型枚举（如 pulse/level/toggle）作为 string 参数保留
            decls.append(f"  parameter string {pid} = \"{default}\"{comma}")
        else:  # string 及其他
            decls.append(f"  parameter {pid} = {default!r}{comma}")
    return decls


def collect_signals(contract):
    """返回 [(channel_id, signal_id, width, from_role, to_role, required)]"""
    sigs = []
    for ch in contract.get("channels", []) or []:
        for sig in ch.get("signals", []) or []:
            sigs.append({
                "channel": ch["id"],
                "id": sig["id"],
                "width": sig.get("width", "1"),
                "from": sig.get("from", ""),
                "to": sig.get("to", ""),
                "required": sig.get("required", True),
            })
    return sigs


def gen_interface(contract, params):
    """生成 SV interface 文件内容。"""
    iface = contract["interface"]
    name = iface["name"]  # e.g. aix_ready_valid
    ifname = f"{name}_if"

    ports = build_port_list(contract, params)
    port_decls = ",\n  ".join(f"input  logic {p}" for p in ports)

    # 参数化：契约 parameters -> SV parameter 列表
    param_decls = build_param_list(contract)
    if param_decls:
        params_head = "\n".join(param_decls)
        head_decls = f"#(\n{params_head}\n)"
    else:
        head_decls = ""

    signals = collect_signals(contract)

    # 端口已有 + 去重
    port_set = set(ports)
    body_signals = [s for s in signals if s["id"] not in port_set]

    # 内部信号声明
    decls = []
    for s in body_signals:
        w = s["width"]
        if w == "1":
            decls.append(f"  logic {s['id']}; // channel={s['channel']}")
        else:
            decls.append(f"  logic {width_to_sv(w, params)} {s['id']}; // channel={s['channel']}")

    # 按角色聚合 modport
    roles = [r["id"] for r in contract.get("roles", []) or []]
    modports = []
    for role in roles:
        outs = []
        ins = []
        for s in signals:
            # 若为系统信号（clk/rst_n），由端口提供，modport 中跳过
            if s["id"] in port_set:
                continue
            if s["from"] == role:
                outs.append(s["id"])
            if s["to"] == role:
                ins.append(s["id"])
        lines = []
        if outs:
            lines.append(f"    output {' , '.join(outs)}")
        if ins:
            lines.append(f"    input  {' , '.join(ins)}")
        if not lines:
            lines.append("    /* no signals */")
        modports.append(
            f"  modport {role} (\n" + ",\n".join(lines) + "\n  );"
        )

    header = (
        f"// Copyright (c) 2026 AIXSILICON\n"
        f"// SPDX-License-Identifier: Apache-2.0\n"
        f"//\n"
        f"// {ifname}: 由 tools/view_generate/view_generate.py 从 YAML Contract 确定性生成。\n"
        f"// 契约来源：{contract.get('interface', {}).get('id', 'unknown')}。禁止手工修改，改契约后重新生成。\n"
        f"\n"
    )

    if port_decls:
        iface_head = f"interface {ifname}{head_decls} (\n  {port_decls}\n);\n"
    elif head_decls:
        iface_head = f"interface {ifname}{head_decls};\n"
    else:
        iface_head = f"interface {ifname};\n"

    body = "\n".join(decls)
    modport_block = "\n\n".join(modports)

    content = header + iface_head + "\n" + body
    if modports:
        content += "\n\n" + modport_block
    content += "\n\nendinterface : " + ifname + "\n"
    return content


def gen_ipxact(contract):
    """生成 IP-XACT busDefinition + abstractionDefinition（可选交换视图）。

    plan §20：IP-XACT 由 YAML 派生，不取代 YAML SSOT。
    """
    iface = contract["interface"]
    family = iface.get("family", "misc")
    name = iface["name"]
    vlv = f"aix:interface:{family}:{iface.get('semantic_version', '0.1.0')}"

    bus_def = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<ipxact:busDefinition xmlns:ipxact="http://www.accellera.org/XMLSchema/IPXACT/1685-2022">\n'
        f'  <ipxact:vendor>aixsilicon</ipxact:vendor>\n'
        f'  <ipxact:library>interface</ipxact:library>\n'
        f'  <ipxact:name>{family}</ipxact:name>\n'
        f'  <ipxact:version>{iface.get("semantic_version", "0.1.0")}</ipxact:version>\n'
        f'  <ipxact:displayName>{name}</ipxact:displayName>\n'
        f'  <ipxact:shortDescription>Derived from {iface.get("id")} (YAML SSOT)</ipxact:shortDescription>\n'
        f'  <ipxact:maxMasters>16</ipxact:maxMasters>\n'
        f'  <ipxact:maxSlaves>16</ipxact:maxSlaves>\n'
        '</ipxact:busDefinition>\n'
    )

    # abstractionDefinition：按 role/from 汇总信号方向
    signals = collect_signals(contract)
    abs_lines = []
    for s in signals:
        if s["width"] == "1":
            w = "1"
        else:
            w = s["width"]
        # 简化方向：from 为 initiator/controller/source 一侧
        direction = "master" if s["from"] in ("initiator", "controller", "source") else "slave"
        abs_lines.append(
            f'    <ipxact:onSystem>\n'
            f'      <ipxact:group>{s["channel"]}</ipxact:group>\n'
            f'      <ipxact:wire>\n'
            f'        <ipxact:direction>{direction}</ipxact:direction>\n'
            f'        <ipxact:width>{w}</ipxact:width>\n'
            f'      </ipxact:wire>\n'
            f'    </ipxact:onSystem>'
        )
    abs_def = (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<ipxact:abstractionDefinition xmlns:ipxact="http://www.accellera.org/XMLSchema/IPXACT/1685-2022">\n'
        f'  <ipxact:vendor>aixsilicon</ipxact:vendor>\n'
        f'  <ipxact:library>interface</ipxact:library>\n'
        f'  <ipxact:name>{family}_abs</ipxact:name>\n'
        f'  <ipxact:version>{iface.get("semantic_version", "0.1.0")}</ipxact:version>\n'
        f'  <ipxact:busType vendor="aixsilicon" library="interface" name="{family}" '
        f'version="{iface.get("semantic_version", "0.1.0")}"/>\n'
        f'  <ipxact:ports>\n'
        + "\n".join(abs_lines) +
        '\n  </ipxact:ports>\n'
        '</ipxact:abstractionDefinition>\n'
    )
    return bus_def, abs_def


def gen_docs(contract):
    """生成 Interface Spec（markdown），供 docs/ 与 Catalog 引用。"""
    iface = contract["interface"]
    name = iface["name"]
    doc = [
        f"# {iface.get('id')} — {name}",
        "",
        f"- **Family**: `{iface.get('family')}`",
        f"- **SemVer**: `{iface.get('semantic_version')}`",
        f"- **Owner**: `{iface.get('owner')}`",
        f"- **Lifecycle**: `{iface.get('lifecycle')}`",
        "",
        "## Roles",
        "",
    ]
    for r in contract.get("roles", []) or []:
        aliases = ", ".join(r.get("aliases", []))
        line = f"- `{r['id']}`"
        if aliases:
            line += f" (aliases: {aliases})"
        doc.append(line)

    doc += ["", "## Parameters", ""]
    for p in contract.get("parameters", []) or []:
        doc.append(f"- `{p['id']}` (type={p.get('type')}, default={p.get('default')})")

    doc += ["", "## Channels / Signals", ""]
    for ch in contract.get("channels", []) or []:
        doc.append(f"### `{ch['id']}` (handshake={ch.get('handshake')})")
        doc.append("")
        doc.append("| Signal | From | To | Width | Required | Capability |")
        doc.append("|---|---|---|---|---|---|")
        for s in ch.get("signals", []) or []:
            doc.append(
                f"| `{s['id']}` | {s.get('from')} | {s.get('to')} | "
                f"{s.get('width')} | {s.get('required', True)} | {s.get('capability', '-')} |"
            )
        doc.append("")

    doc += ["## Capabilities", ""]
    for c in contract.get("capabilities", []) or []:
        doc.append(f"- `{c['id']}` (default={c.get('default')})")

    doc += ["", "## Semantics", ""]
    for k, v in (contract.get("semantics", {}) or {}).items():
        doc.append(f"- **{k}**: `{v}`")

    doc += ["", "## Views", ""]
    for k, v in (contract.get("views", {}) or {}).items():
        doc.append(f"- `{k}`: {v}")
    doc.append("")
    return "\n".join(doc)


def gen_flat_wrapper(contract, prefix="s"):
    """生成 Flat Port Wrapper（View C，plan §6.4）。

    命名规则：<prefix>_<channel>_<signal>_<dir>（dir: i/o/oe_o）。
    """
    iface = contract["interface"]
    name = iface["name"]
    wrapper_name = f"{name}_flat_wrapper"

    params = {p["id"]: p for p in contract.get("parameters", []) or []}
    param_decls = build_param_list(contract)
    if param_decls:
        params_head = "\n".join(param_decls)
        head_decls = f"#(\n{params_head}\n)"
    else:
        head_decls = ""

    ports = build_port_list(contract, params)
    port_set = set(ports)
    signals = [s for s in collect_signals(contract) if s["id"] not in port_set]

    port_lines = []
    assign_lines = []
    for s in signals:
        chan = s["channel"]
        pname = f"{prefix}_{chan}_{s['id']}_{'i' if s['from'] in ('initiator', 'controller', 'source') else 'o'}"
        width = s["width"]
        port_lines.append(f"  input  logic {width_to_sv(width, params)} {pname},")
        assign_lines.append(f"  assign {pname} = 1'b0;  // placeholder for {s['id']}")

    port_block = "\n".join(port_lines).rstrip(",")

    content = (
        f"// Copyright (c) 2026 AIXSILICON\n"
        f"// SPDX-License-Identifier: Apache-2.0\n"
        f"//\n"
        f"// {wrapper_name}: 由 tools/view_generate/view_generate.py 生成的 Flat Port Wrapper（View C）。\n"
        f"// 命名规则 <prefix>_<chan>_<sig>_<dir>（plan §6.4）。禁止手工修改。\n"
        f"//\n"
        f"module {wrapper_name}{head_decls} (\n{port_block}\n);\n\n"
        + "\n".join(assign_lines) +
        f"\n\nendmodule : {wrapper_name}\n"
    )
    return content


def main():
    parser = argparse.ArgumentParser(description="YAML Contract -> SV interface view generator")
    parser.add_argument("--contract", default=None, help="contract YAML path")
    parser.add_argument("--out", default="generated", help="output dir (default: generated/)")
    parser.add_argument("--all", action="store_true", help="generate for all interface families")
    parser.add_argument("--root", default=".", help="root dir for --all scan")
    parser.add_argument("--check-only", action="store_true",
                        help="only verify generated views are up-to-date (CI gate)")
    parser.add_argument("--ipxact", action="store_true",
                        help="also generate IP-XACT busDefinition/abstractionDefinition")
    parser.add_argument("--flat", action="store_true",
                        help="also generate Flat Port Wrapper (View C)")
    parser.add_argument("--docs", action="store_true",
                        help="also generate Interface Spec (markdown)")
    args = parser.parse_args()

    if args.all:
        contracts = []
        for dirpath, _d, files in os.walk(args.root):
            for f in files:
                if f.endswith(".interface.yaml"):
                    contracts.append(os.path.join(dirpath, f))
        contracts.sort()
    elif args.contract:
        contracts = [args.contract]
    else:
        parser.error("provide --contract or --all")

    def write_derived(contract, family):
        """生成并写出派生视图：IP-XACT（--ipxact）与 Flat Wrapper（--flat）。"""
        if args.ipxact:
            bus_def, abs_def = gen_ipxact(contract)
            ipx_dir = os.path.join(args.out, "ipxact", family)
            os.makedirs(ipx_dir, exist_ok=True)
            for suffix, payload in (("busdef", bus_def), ("absdef", abs_def)):
                ipx_path = os.path.join(ipx_dir, f"{iface['name']}_{suffix}.xml")
                with open(ipx_path, "w", encoding="utf-8") as fh:
                    fh.write(payload)
                sys.stdout.write(f"[GEN] {ipx_path}\n")
        if args.flat:
            flat_dir = os.path.join(args.out, family)
            os.makedirs(flat_dir, exist_ok=True)
            flat_path = os.path.join(flat_dir, f"{iface['name']}_flat_wrapper.sv")
            with open(flat_path, "w", encoding="utf-8") as fh:
                fh.write(gen_flat_wrapper(contract))
            sys.stdout.write(f"[GEN] {flat_path}\n")
        if args.docs:
            docs_dir = os.path.join(args.out, "docs", family)
            os.makedirs(docs_dir, exist_ok=True)
            docs_path = os.path.join(docs_dir, f"{iface['name']}_spec.md")
            with open(docs_path, "w", encoding="utf-8") as fh:
                fh.write(gen_docs(contract))
            sys.stdout.write(f"[GEN] {docs_path}\n")

    changed = 0
    for cpath in contracts:
        contract = load_yaml(cpath)
        if contract is None:
            changed += 1
            continue
        iface = contract.get("interface")
        if not iface:
            continue
        params = {p["id"]: p for p in contract.get("parameters", []) or []}
        content = gen_interface(contract, params)

        family = iface.get("family", "misc")
        out_dir = os.path.join(args.out, family)
        os.makedirs(out_dir, exist_ok=True)
        out_path = os.path.join(out_dir, f"{iface['name']}_if.sv")

        # 确定性 hash
        digest = hashlib.sha256(content.encode("utf-8")).hexdigest()[:16]

        if os.path.exists(out_path):
            with open(out_path, "r", encoding="utf-8") as fh:
                if fh.read() == content:
                    sys.stdout.write(f"[OK] {out_path} (up-to-date, sha256={digest})\n")
                    write_derived(contract, family)
                    continue

        if args.check_only:
            sys.stderr.write(f"[STALE] {out_path} is out of date (sha256={digest})\n")
            changed += 1
            continue

        with open(out_path, "w", encoding="utf-8") as fh:
            fh.write(content)
        sys.stdout.write(f"[GEN] {out_path} (sha256={digest})\n")
        changed += 1
        write_derived(contract, family)

    if args.check_only:
        if changed:
            sys.stderr.write(f"FAILED: {changed} generated view(s) stale\n")
            return 1
        sys.stdout.write("OK: all generated views up-to-date\n")
        return 0

    sys.stdout.write(f"OK: generated/updated {changed} view(s)\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
