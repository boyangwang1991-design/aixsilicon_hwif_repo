# Changelog — aix_axi

遵循 SemVer（见 [`plan.md`](../../plan.md:952) 第 16.1 节）。packed struct 字段增删视为破坏性变更。

## [1.0.0] - Unreleased

### Added
- 初始 AXI4 端点契约 `contract/axi.interface.yaml`；
- AXI4 基础 Profile `axi4_base.profile.yaml`（无 ATOP，USER/Exclusive 可选）；
- View A：`rtl/aix_axi_pkg.sv`（req/rsp 聚合，参考 PULP AXI 模式）；
- View B：`rtl/aix_axi_if.sv`（initiator/target modport）；
- View C：`rtl/aix_axi_flat_wrapper.sv`（扁平端口模板）；
- include 宏：`aix_axi_typedef.svh`、`aix_axi_assign.svh`；
- FuseSoC Core `aix_interface_axi.core`（default/contract/lint target）。

### Notes
- 生命周期 `draft`，禁止项目依赖；
- 商用规范正文不复制，仅记录受控引用。
