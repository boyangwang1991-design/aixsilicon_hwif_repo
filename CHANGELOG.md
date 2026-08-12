# Changelog

本仓库遵循 [Semantic Versioning](https://semver.org/)。每个接口族维护独立
`CHANGELOG.md`；本文件记录仓库级（结构、工具、Schema、公共底座）变更。

## [Unreleased]

### Added
- 初始化仓库骨架，覆盖 [`plan.md`](plan.md:398) 第 8 节推荐结构：
  - `schema/`：Interface Contract / Profile / Binding / Compatibility / Release Manifest 5 个 YAML Schema；
  - `docs/`：architecture / modeling-guide / naming-convention / compatibility-guide / integration-guide；
  - `common/`：公共类型底座（YAML Contract + SV package/typedef + FuseSoC Core）；
  - `foundation/`：clock、reset、ready_valid、req_ack、event（L0）；
  - `system/`：interrupt、error_report 及 clock_control / reset_control / power_state 骨架（L1）；
  - `memory/`：reg_native、memory_1rw、fifo_push_pop 及 memory_1r1w 骨架（L2）；
  - `bus/`：apb、axi_lite、axi、axi_stream 及 ahb_lite、obi 骨架（L3）；
  - `link/`：credit_link、packet_stream 及 noc_flit 骨架（L3）；
  - `peripheral/`、`dft_debug/`、`safety_security/`：接口族骨架；
  - `profiles/`、`bindings/`、`generated/`、`examples/`、`tests/`、`tools/`；
- 仓库级根文档：`README.md`、`NOTICE`、`CONTRIBUTING.md`、`CODEOWNERS`、`LICENSES/`。

### Notes
- 框架阶段仅为工程骨架；各接口族的成熟度均为 `draft`，禁止项目依赖；
- `generated/` 下派生文件由 CI/工具生成，禁止手工修改。
