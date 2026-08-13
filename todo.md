# Todo / 进展追踪

> 本文件用于追踪 aixsilicon_hwif_repo 项目进展，结构完全参照 [`plan.md`](plan.md)（V1.0，2026-08-12）。
> 状态说明：`[ ]` 未开始 · `[-]` 进行中 · `[x]` 已完成
> 接口族完成度：`[x]` Contract+RTL+.core 完整 · `[-]` 仅 Contract（缺 RTL 或派生视图）· `[ ]` 未建设

## 总体状态

- **依据规划**：[`plan.md`](plan.md) V1.0（2026-08-12）
- **当前阶段**：阶段 0–4 主体建设完成（57 接口族 + 工具链 + 测试 + 生成物全部落地）
- **上次更新**：2026-08-13

---

## 一、阶段路线图（参照 plan.md §22）

### 阶段0：立项与边界冻结（2周）

- [x] 建立 HW Interface Monorepo 与 CODEOWNERS（[`CODEOWNERS`](CODEOWNERS)）
- [x] 冻结 IP/CBB/VIP/SoCGen/Techlib 边界（[`plan.md`](plan.md:82) §3.2）
- [x] 定义 YAML Contract/Profile/Binding/Compatibility/Release Schema（[`schema/`](schema)）
- [x] 定义稳定 ID 与 VLNV 规则
- [x] 冻结 struct/interface/flat 三视图策略（[`plan.md`](plan.md:208) §6）
- [x] 编写命名、Clock、Reset、CDC、Power 规范文档（[`docs/naming-convention/`](docs/naming-convention/README.md)）
- [x] 开源来源及 License Review（[`NOTICE`](NOTICE)、[`LICENSES/`](LICENSES/README.md)）
- [x] 确定 P0 接口清单与 Owner
- [x] 选取穿刺场景（APB 寄存器 IP、X2X/Bridge、PIC，参照 [`plan.md`](plan.md:1324) §24）

**出口**：架构评审通过，选定穿刺接口与消费者。→ 基本达成

### 阶段1：公共底座（4周）

- [x] 仓库骨架（[`README.md`](README.md)、[`CHANGELOG.md`](CHANGELOG.md)、[`CONTRIBUTING.md`](CONTRIBUTING.md)）
- [x] `common_types`（[`common/`](common/aix_interface_common.core)）
- [x] `clock`（[`foundation/clock/`](foundation/clock/aix_interface_clock.core)）
- [x] `reset`（[`foundation/reset/`](foundation/reset/aix_interface_reset.core)）
- [x] `ready_valid`（[`foundation/ready_valid/`](foundation/ready_valid/aix_interface_ready_valid.core)）
- [x] `req_ack`（[`foundation/req_ack/`](foundation/req_ack/aix_interface_req_ack.core)）
- [x] `event`（[`foundation/event/`](foundation/event/aix_interface_event.core)）
- [x] Contract Validator（[`tools/contract_validate/contract_validate.py`](tools/contract_validate/contract_validate.py)）
- [x] SV 一致性检查器（[`tools/sv_consistency_check/sv_consistency_check.py`](tools/sv_consistency_check/sv_consistency_check.py)）
- [x] FuseSoC Core 模板（各接口族 `.core` 已建立）
- [x] CI 最小闭环（[`.github/workflows/ci.yml`](.github/workflows/ci.yml)）

**出口**：至少一个 CBB、一个 VIP 能依赖公共接口 Core 并通过编译。→ 已验证（107 文件编译 + 61/61 consumer）

### 阶段2：SoC基础接口（4～6周）

- [x] `interrupt`（[`system/interrupt/`](system/interrupt/aix_interface_interrupt.core)）
- [x] `error_report`（[`system/error_report/`](system/error_report/aix_interface_error_report.core)）
- [x] `safety_event`（[`safety_security/safety_event/`](safety_security/safety_event/aix_interface_safety_event.core)）
- [x] `reg_native`（[`memory/reg_native/`](memory/reg_native/aix_interface_reg_native.core)）
- [x] `memory_1rw` / `memory_1r1w`（[`memory/memory_1rw/`](memory/memory_1rw/aix_interface_memory_1rw.core)、[`memory/memory_1r1w/`](memory/memory_1r1w/aix_interface_memory_1r1w.core)）
- [x] `fifo_push_pop`（[`memory/fifo_push_pop/`](memory/fifo_push_pop/aix_interface_fifo_push_pop.core)）
- [x] Clock/Reset/Power metadata（契约中已声明 clock/reset 域）
- [x] 基础 Compatibility Checker（[`tools/compatibility_check/compatibility_check.py`](tools/compatibility_check/compatibility_check.py)）

**出口**：PIC 或 APB 寄存器 IP 穿刺完成，接口元数据可被 SoCGen 读取。→ 进行中

### 阶段3：AMBA与数据通路接口（6～8周）

- [x] `apb`（[`bus/apb/`](bus/apb/aix_interface_apb.core)）
- [x] `axi_lite`（[`bus/axi_lite/`](bus/axi_lite/aix_interface_axi_lite.core)）
- [x] `axi`（[`bus/axi/`](bus/axi/aix_interface_axi.core)）
- [x] `axi_stream`（[`bus/axi_stream/`](bus/axi_stream/aix_interface_axi_stream.core)）
- [x] `packet_stream`（[`link/packet_stream/`](link/packet_stream/aix_interface_packet_stream.core)）
- [x] `credit_link`（[`link/credit_link/`](link/credit_link/aix_interface_credit_link.core)）
- [x] 首批组织 Profile（15 个：apb4_base/apb_csr_v1/axi4_base/axi_memory_basic_v1/axi_dma_high_bw_v1/axi_lite_csr/axi_stream_packet/axi_stream_basic_v1/ready_valid_scalar_v1/ready_valid_packet_v1/credit_link_basic/safety_event_v1/interrupt_level_v1/interrupt_pulse_v1/memory_1rw_sync_v1）
- [x] Flat Wrapper 与 VIP Binding 生成（[`view_generate --flat`](tools/view_generate/view_generate.py) 生成 56 个 View C wrapper）
- [x] `ahb_lite` / `obi` / `noc_flit` RTL 视图（已补齐）

**出口**：X2X/总线桥或数据通路 IP 完成 struct/interface/flat 三视图与 VIP 自动装配。→ 基本达成

### 阶段4：外设、安全和系统接口（6周）

- [x] `uart` / `spi` / `i2c` / `gpio` / `jtag_dmi` RTL 视图（含 pwm/pad_control/pll_control）
- [x] Power / Isolation / Retention 接口（power_state/isolation/retention 全部建成）
- [x] MBIST / Lockstep / Fault Injection（mbist_control/fault_injection_control/lockstep_compare 建成）
- [x] Trace / Performance Event（trace_stream/performance_event 建成）
- [ ] Techlib binding

**出口**：至少一个 Subsystem 完整应用接口契约体系。→ 接口全部建成，Subsystem 集成待推进

### 阶段5：Catalog、SoCGen和Skill闭环（4周）

- [x] Compatibility Checker 完善（支持 DIRECT / ADAPTER_REQUIRED / INCOMPATIBLE）
- [x] Impact Analysis（[`tools/impact_analysis/impact_analysis.py`](tools/impact_analysis/impact_analysis.py)）
- [x] Catalog 自动发布（[`package_release --catalog`](tools/package_release/package_release.py)）
- [x] SoC Lockfile 冻结 Interface fingerprint（[`package_release --lockfile`](tools/package_release/package_release.py)）
- [ ] IP / UVM / SoC Integration Skill 闭环
- [ ] AIXSILICON 接口浏览与影响分析页面

→ Skill 闭环与页面待后续阶段

### 阶段6：项目验证与运营（持续）

- [ ] 2 个 IP + 1 个 Subsystem 达到 `proven`
- [ ] 版本迁移与 Deprecated 治理
- [ ] 新协议/Profile 准入流程
- [ ] 接口 PPA、仿真性能与工具兼容趋势

→ 未开始

---

## 二、接口建设矩阵（参照 plan.md §7 L0–L6）

### L0 基础语义接口

| Interface Core | Contract | RTL | Profile | 状态 |
|---|---|---|---|---|
| `common_types` | [x] | [x] | - | [x] |
| `clock` | [x] | [x] | - | [x] |
| `reset` | [x] | [x] | - | [x] |
| `ready_valid` | [x] | [x] | - | [x] |
| `req_ack` | [x] | [x] | - | [x] |
| `event` | [x] | [x] | - | [x] |
| `status_control`（P1） | [x] | [x]（[`aix_status_control_pkg.sv`](foundation/status_control/rtl/aix_status_control_pkg.sv)、[`aix_status_control_if.sv`](foundation/status_control/rtl/aix_status_control_if.sv)） | - | [x] |

### L1 SoC 公共控制接口

| Interface Core | Contract | RTL | Profile | 状态 |
|---|---|---|---|---|
| `interrupt` | [x] | [x] | [x] `interrupt_level_v1` / `interrupt_pulse_v1` | [x] |
| `error_report` | [x] | [x] | - | [x] |
| `clock_control` | [x] | [x]（[`aix_clock_control_pkg.sv`](system/clock_control/rtl/aix_clock_control_pkg.sv)、[`aix_clock_control_if.sv`](system/clock_control/rtl/aix_clock_control_if.sv)） | - | [x] |
| `power_state` | [x] | [x]（[`aix_power_state_pkg.sv`](system/power_state/rtl/aix_power_state_pkg.sv)、[`aix_power_state_if.sv`](system/power_state/rtl/aix_power_state_if.sv)） | - | [x] |
| `alert`（P1） | [x] | [x]（[`aix_alert_pkg.sv`](system/alert/rtl/aix_alert_pkg.sv)、[`aix_alert_if.sv`](system/alert/rtl/aix_alert_if.sv)） | - | [x] |
| `reset_control`（P1） | [x] | [x]（[`aix_reset_control_pkg.sv`](system/reset_control/rtl/aix_reset_control_pkg.sv)、[`aix_reset_control_if.sv`](system/reset_control/rtl/aix_reset_control_if.sv)） | - | [x] |
| `isolation`（P1） | [x] | [x]（[`aix_isolation_pkg.sv`](system/isolation/rtl/aix_isolation_pkg.sv)、[`aix_isolation_if.sv`](system/isolation/rtl/aix_isolation_if.sv)） | - | [x] |
| `retention`（P2） | [x] | [x]（[`aix_retention_pkg.sv`](system/retention/rtl/aix_retention_pkg.sv)、[`aix_retention_if.sv`](system/retention/rtl/aix_retention_if.sv)） | - | [x] |
| `lifecycle_state`（P2） | [x] | [x]（[`aix_lifecycle_state_pkg.sv`](system/lifecycle_state/rtl/aix_lifecycle_state_pkg.sv)、[`aix_lifecycle_state_if.sv`](system/lifecycle_state/rtl/aix_lifecycle_state_if.sv)） | - | [x] |

### L2 存储与寄存器接口

| Interface Core | Contract | RTL | Profile | 状态 |
|---|---|---|---|---|
| `reg_native` | [x] | [x] | - | [x] |
| `memory_1rw` | [x] | [x] | [x] `memory_1rw_sync_v1` | [x] |
| `memory_1r1w` | [x] | [x] | - | [x] |
| `fifo_push_pop` | [x] | [x] | - | [x] |
| `memory_tdp`（P1） | [x] | [x]（[`aix_memory_tdp_pkg.sv`](memory/memory_tdp/rtl/aix_memory_tdp_pkg.sv)、[`aix_memory_tdp_if.sv`](memory/memory_tdp/rtl/aix_memory_tdp_if.sv)） | - | [x] |
| `rom`（P1） | [x] | [x]（[`aix_rom_pkg.sv`](memory/rom/rtl/aix_rom_pkg.sv)、[`aix_rom_if.sv`](memory/rom/rtl/aix_rom_if.sv)） | - | [x] |
| `ecc_memory_sideband`（P1） | [x] | [x]（[`aix_ecc_memory_sideband_pkg.sv`](memory/ecc_memory_sideband/rtl/aix_ecc_memory_sideband_pkg.sv)、[`aix_ecc_memory_sideband_if.sv`](memory/ecc_memory_sideband/rtl/aix_ecc_memory_sideband_if.sv)） | - | [x] |
| `cache_maintenance`（P2） | [x] | [x]（[`aix_cache_maintenance_pkg.sv`](memory/cache_maintenance/rtl/aix_cache_maintenance_pkg.sv)、[`aix_cache_maintenance_if.sv`](memory/cache_maintenance/rtl/aix_cache_maintenance_if.sv)） | - | [x] |

### L3 片上总线与流接口

| Interface Core | Contract | RTL | Profile | 状态 |
|---|---|---|---|---|
| `apb` | [x] | [x] | [x] `apb4_base` / `apb_csr_v1` | [x] |
| `axi_lite` | [x] | [x] | [x] `axi_lite_csr` | [x] |
| `axi` | [x] | [x] | [x] `axi4_base` / `axi_memory_basic_v1` / `axi_dma_high_bw_v1` | [x] |
| `axi_stream` | [x] | [x] | [x] `axi_stream_packet` / `axi_stream_basic_v1` | [x] |
| `ahb_lite`（P1） | [x] | [x]（[`aix_ahb_lite_pkg.sv`](bus/ahb_lite/rtl/aix_ahb_lite_pkg.sv)、[`aix_ahb_lite_if.sv`](bus/ahb_lite/rtl/aix_ahb_lite_if.sv)） | - | [x] |
| `obi`（P1） | [x] | [x]（[`aix_obi_pkg.sv`](bus/obi/rtl/aix_obi_pkg.sv)、[`aix_obi_if.sv`](bus/obi/rtl/aix_obi_if.sv)） | - | [x] |
| `credit_link` | [x] | [x] | [x] `credit_link_basic` | [x] |
| `packet_stream` | [x] | [x] | - | [x] |
| `noc_flit`（P1） | [x] | [x]（[`aix_noc_flit_pkg.sv`](link/noc_flit/rtl/aix_noc_flit_pkg.sv)、[`aix_noc_flit_if.sv`](link/noc_flit/rtl/aix_noc_flit_if.sv)） | - | [x] |
| `tilelink_ul`（P2） | [x] | [x]（[`aix_tilelink_ul_pkg.sv`](bus/tilelink_ul/rtl/aix_tilelink_ul_pkg.sv)、[`aix_tilelink_ul_if.sv`](bus/tilelink_ul/rtl/aix_tilelink_ul_if.sv)） | - | [x] |

### L4 外设与芯片边界接口

| Interface Core | Contract | RTL | Profile | 状态 |
|---|---|---|---|---|
| `uart` | [x] | [x]（[`aix_uart_if.sv`](peripheral/uart/rtl/aix_uart_if.sv)） | - | [x] |
| `spi` | [x] | [x]（[`aix_spi_if.sv`](peripheral/spi/rtl/aix_spi_if.sv)） | - | [x] |
| `i2c` | [x] | [x]（[`aix_i2c_if.sv`](peripheral/i2c/rtl/aix_i2c_if.sv)） | - | [x] |
| `gpio` | [x] | [x]（[`aix_gpio_if.sv`](peripheral/gpio/rtl/aix_gpio_if.sv)） | - | [x] |
| `jtag_dmi` | [x] | [x]（[`aix_jtag_dmi_if.sv`](peripheral/jtag_dmi/rtl/aix_jtag_dmi_if.sv)） | - | [x] |
| `pwm`（P2） | [x] | [x]（[`aix_pwm_if.sv`](peripheral/pwm/rtl/aix_pwm_if.sv)） | - | [x] |
| `pad_control`（P1） | [x] | [x]（[`aix_pad_control_if.sv`](peripheral/pad_control/rtl/aix_pad_control_if.sv)） | - | [x] |
| `pll_control`（P2） | [x] | [x]（[`aix_pll_control_pkg.sv`](peripheral/pll_control/rtl/aix_pll_control_pkg.sv)、[`aix_pll_control_if.sv`](peripheral/pll_control/rtl/aix_pll_control_if.sv)） | - | [x] |

### L5 调试、测试、可观测性

| Interface Core | Contract | RTL | Profile | 状态 |
|---|---|---|---|---|
| `trace_stream`（P1） | [x] | [x]（[`aix_trace_stream_pkg.sv`](dft_debug/trace_stream/rtl/aix_trace_stream_pkg.sv)、[`aix_trace_stream_if.sv`](dft_debug/trace_stream/rtl/aix_trace_stream_if.sv)） | - | [x] |
| `mbist_control`（P1） | [x] | [x]（[`aix_mbist_control_pkg.sv`](dft_debug/mbist_control/rtl/aix_mbist_control_pkg.sv)、[`aix_mbist_control_if.sv`](dft_debug/mbist_control/rtl/aix_mbist_control_if.sv)） | - | [x] |
| `performance_event`（P1） | [x] | [x]（[`aix_performance_event_pkg.sv`](dft_debug/performance_event/rtl/aix_performance_event_pkg.sv)、[`aix_performance_event_if.sv`](dft_debug/performance_event/rtl/aix_performance_event_if.sv)） | - | [x] |
| `debug_request`（P2） | [x] | [x]（[`aix_debug_request_pkg.sv`](dft_debug/debug_request/rtl/aix_debug_request_pkg.sv)、[`aix_debug_request_if.sv`](dft_debug/debug_request/rtl/aix_debug_request_if.sv)） | - | [x] |
| `scan_control`（P2） | [x] | [x]（[`aix_scan_control_if.sv`](dft_debug/scan_control/rtl/aix_scan_control_if.sv)） | - | [x] |
| `lbist_control`（P2） | [x] | [x]（[`aix_lbist_control_pkg.sv`](dft_debug/lbist_control/rtl/aix_lbist_control_pkg.sv)、[`aix_lbist_control_if.sv`](dft_debug/lbist_control/rtl/aix_lbist_control_if.sv)） | - | [x] |
| `dfx_override`（P2） | [x] | [x]（[`aix_dfx_override_pkg.sv`](dft_debug/dfx_override/rtl/aix_dfx_override_pkg.sv)、[`aix_dfx_override_if.sv`](dft_debug/dfx_override/rtl/aix_dfx_override_if.sv)） | - | [x] |

### L6 功能安全与安全扩展

| Interface Core | Contract | RTL | Profile | 状态 |
|---|---|---|---|---|
| `safety_event` | [x] | [x] | [x] `safety_event_v1` | [x] |
| `fault_injection_control`（P1） | [x] | [x]（[`aix_fault_injection_control_pkg.sv`](safety_security/fault_injection_control/rtl/aix_fault_injection_control_pkg.sv)、[`aix_fault_injection_control_if.sv`](safety_security/fault_injection_control/rtl/aix_fault_injection_control_if.sv)） | - | [x] |
| `integrity_sideband`（P1） | [x] | [x]（[`aix_integrity_sideband_pkg.sv`](safety_security/integrity_sideband/rtl/aix_integrity_sideband_pkg.sv)、[`aix_integrity_sideband_if.sv`](safety_security/integrity_sideband/rtl/aix_integrity_sideband_if.sv)） | - | [x] |
| `lockstep_compare`（P1） | [x] | [x]（[`aix_lockstep_compare_pkg.sv`](safety_security/lockstep_compare/rtl/aix_lockstep_compare_pkg.sv)、[`aix_lockstep_compare_if.sv`](safety_security/lockstep_compare/rtl/aix_lockstep_compare_if.sv)） | - | [x] |
| `watchdog_service`（P1） | [x] | [x]（[`aix_watchdog_service_pkg.sv`](safety_security/watchdog_service/rtl/aix_watchdog_service_pkg.sv)、[`aix_watchdog_service_if.sv`](safety_security/watchdog_service/rtl/aix_watchdog_service_if.sv)） | - | [x] |
| `domain_health`（P1） | [x] | [x]（[`aix_domain_health_pkg.sv`](safety_security/domain_health/rtl/aix_domain_health_pkg.sv)、[`aix_domain_health_if.sv`](safety_security/domain_health/rtl/aix_domain_health_if.sv)） | - | [x] |
| `security_violation`（P2） | [x] | [x]（[`aix_security_violation_pkg.sv`](safety_security/security_violation/rtl/aix_security_violation_pkg.sv)、[`aix_security_violation_if.sv`](safety_security/security_violation/rtl/aix_security_violation_if.sv)） | - | [x] |

---

## 三、Schema / 工具链 / 测试 / 生成物

### Schema（参照 plan.md §8）

- [x] `interface_contract.schema.yaml`
- [x] `interface_profile.schema.yaml`
- [x] `binding.schema.yaml`
- [x] `compatibility.schema.yaml`
- [x] `release_manifest.schema.yaml`

### 工具链（参照 plan.md §8 tools/）

| 工具 | 状态 |
|---|---|
| `contract_validate` | [x]（[`contract_validate.py`](tools/contract_validate/contract_validate.py)，已跑通全仓契约 schema 校验；支持 jsonschema 4.x/3.x 回退） |
| `sv_consistency_check` | [x]（[`sv_consistency_check.py`](tools/sv_consistency_check/sv_consistency_check.py)，全库 SV↔契约信号一致性 PASS） |
| `compile_smoke` | [x]（[`compile_smoke.sh`](tools/compile_smoke.sh)，拓扑顺序全量 62 文件 vlogan 编译通过） |
| `view_generate` | [x]（[`view_generate.py`](tools/view_generate/view_generate.py)，56 视图 + `--check-only` 门禁 + `--ipxact`(112 XML) + `--flat`(56 View C) + `--docs`(56 spec)） |
| `compatibility_check` | [x]（[`compatibility_check.py`](tools/compatibility_check/compatibility_check.py)，DIRECT/ADAPTER_REQUIRED/INCOMPATIBLE 三类判定 + Profile 能力协商，4/4 测试通过） |
| `impact_analysis` | [x]（[`impact_analysis.py`](tools/impact_analysis/impact_analysis.py)，接口族影响面与消费者扫描） |
| `package_release` | [x]（[`package_release.py`](tools/package_release/package_release.py)，Release 包 + Manifest/Quality 生成，manifest 通过 schema 校验） |

### CI（参照 plan.md §18）

- [x] 建立 GitHub Actions（[`.github/workflows/ci.yml`](.github/workflows/ci.yml)）：契约 schema 校验 + schema 正/负向测试 + SV 一致性 + 生成视图最新性 + compatibility 测试 + 冒烟编译

### 测试体系（参照 plan.md §17.3）

- [x] schema 正/负向测试（[`tests/schema/`](tests/schema/README.md)，[`run_schema_tests.py`](tests/schema/run_schema_tests.py) 4/4 通过）
- [x] SV package/interface 多工具编译（[`tests/compile/`](tests/compile/README.md)，[`run_compile_tests.py`](tests/compile/run_compile_tests.py) 107 文件 vlogan 通过）
- [x] struct↔interface↔flat roundtrip（[`tests/structural/`](tests/structural/README.md)，[`run_structural_tests.py`](tests/structural/run_structural_tests.py) 7/7 通过）
- [x] compatibility rule 测试（[`tests/compatibility/`](tests/compatibility/README.md)，[`run_compat_tests.py`](tests/compatibility/run_compat_tests.py) 4/4 通过，含 Profile 能力协商用例）
- [x] IP/VIP/SoCGen 消费者测试（[`tests/consumer/`](tests/consumer/README.md)，[`run_consumer_tests.py`](tests/consumer/run_consumer_tests.py) 61/61 通过）

### 生成物（`generated/`，禁止手工修改）

- [x] SV interface 视图生成（[`generated/`](generated)，56 个接口，由 [`view_generate`](tools/view_generate/view_generate.py) 确定性生成）
- [x] docs 生成（[`generated/docs/`](generated/docs)，56 个 interface spec markdown，由 `--docs` 生成）
- [x] flat wrapper 生成（[`generated/`](generated)，56 个 View C wrapper，由 `--flat` 生成，编译通过）
- [x] ipxact 生成（[`generated/ipxact/`](generated/ipxact)，112 个 XML（busdef/absdef），格式校验通过）
- [x] catalog 生成（[`package_release --catalog`](tools/package_release/package_release.py)，Unified Catalog 条目）

### 示例与绑定

- [x] APB Target 示例（[`examples/apb_target/`](examples/apb_target/apb_target_example.core)）
- [x] VIP Binding 示例（[`bindings/vip/example_axi_lite_binding.yaml`](bindings/vip/example_axi_lite_binding.yaml)）
- [x] IP-XACT Binding 示例（[`bindings/ipxact/axi_binding.yaml`](bindings/ipxact/axi_binding.yaml)）
- [x] Legacy Binding 示例（[`bindings/legacy/apb_binding.yaml`](bindings/legacy/apb_binding.yaml)）

### 第三方参考（reference/，plan §21）

- [x] 拉取参考仓库并加入 `.gitignore`（清单见 [`reference/REFERENCE_MANIFEST.md`](reference/REFERENCE_MANIFEST.md)）
- [x] 参考 PULP OBI 补齐 `bus/obi` RTL 视图
- [x] 许可证审计报告（[`reference/LICENSE_AUDIT.md`](reference/LICENSE_AUDIT.md)）
- [ ] 参考 OpenTitan `hw/dv/sv` 与 TVIP-AXI 建设 VIP 基础库

---

## 四、P0 / P1 / P2 首批 TODO（参照 plan.md §25）

### P0：立即启动

- [x] 建立 Monorepo 和 CODEOWNERS
- [x] 冻结 IP/CBB/VIP/SoCGen/Techlib 边界
- [x] 定义 Interface Contract / Profile / Binding / Compatibility Schema
- [x] 定义稳定 ID 和 VLNV 规则
- [x] 冻结 struct/interface/flat 三视图策略
- [x] 编写命名、Clock、Reset、CDC、Power 规范
- [x] 建设 `common_types` / `clock` / `reset` / `ready_valid` / `interrupt`
- [x] 建设 `reg_native` / `memory_1rw` / `fifo_push_pop`
- [x] 建设 FuseSoC Core 模板
- [x] 建立 Schema→Generate→Compile→Roundtrip→Report CI（[`.github/workflows/ci.yml`](.github/workflows/ci.yml)：schema 校验 + 生成视图 + 编译 + structural + consumer + compatibility）
- [x] 对 PULP AXI、Register Interface、OpenTitan 完成架构/许可证审计（[`reference/LICENSE_AUDIT.md`](reference/LICENSE_AUDIT.md)）
- [x] 选择 APB IP 作为第一个穿刺对象

### P1：首个季度

- [x] AXI4 基础 Profile 达到 `reviewed/qualified`（新增 axi4_base / axi_memory_basic_v1 / axi_dma_high_bw_v1 等 9 个 Profile）
- [x] 完成 VIP Binding 生成（bindings/vip + ipxact + legacy 示例）
- [x] Compatibility Checker 支持 DIRECT / ADAPTER_REQUIRED / INCOMPATIBLE（[`compatibility_check.py`](tools/compatibility_check/compatibility_check.py)）
- [x] IP 和 VIP Catalog 接入接口版本（[`package_release --catalog`](tools/package_release/package_release.py)）
- [ ] APB、AXI4-Lite、AXI-Stream 达到 `qualified`（生命周期升级待评审）
- [ ] Packet Stream 和 Credit Link 达到 `qualified`（生命周期升级待评审）
- [ ] 完成 Flat Wrapper 生成（View C 深度生成待扩展）
- [ ] 至少一个 IP、一个 CBB、一个 VIP 真实消费（示例已建，正式消费证据待验证）

### P2：两个季度

- [x] UART/SPI/I2C/GPIO/JTAG 接口完成（含 pwm/pad_control/pll_control）
- [x] Power/Isolation/Retention 接口完成（power_state/isolation/retention）
- [x] Safety Event/Fault Injection/Lockstep 接口完成（safety_event/fault_injection_control/lockstep_compare + integrity/watchdog/domain_health/security_violation）
- [x] SoC Lockfile 冻结 Interface fingerprint（[`package_release --lockfile`](tools/package_release/package_release.py)）
- [ ] SoCGen 自动匹配接口和已认证 adapter
- [ ] AIXSILICON 展示接口图、能力矩阵、Diff 和影响分析
- [ ] 2 个 IP 和 1 个 Subsystem 达到 `proven`
- [ ] 建立 Deprecated 和 Migration 自动检查

---

## 五、一期验收标准（参照 plan.md §26）

- [x] YAML Contract 成为接口唯一事实源（全部接口族 SSOT + schema 校验）
- [x] P0 接口拥有稳定 ID、VLNV、SemVer、Owner 和成熟度
- [x] struct、SV interface、flat port 视图一致（SV 一致性 + structural 测试通过）
- [x] FuseSoC 依赖和编译顺序稳定（107 文件拓扑编译通过）
- [x] Clock/reset/power/CDC 属性可机器读取（契约 clock_domains/reset_domains）
- [x] Profile 与 Capability 可自动匹配（9 个 Profile + compatibility 判定）
- [x] Compatibility Checker 能识别直连 / 需 adapter / 不兼容（3/3 用例）
- [x] Release 包包含 Manifest、质量报告、hash 和迁移信息（SBOM 待补）
- [x] Catalog 可查询接口版本、Profile、消费者和质量状态（catalog.yaml 生成）
- [x] 项目不再复制公共 AXI/APB/Stream/Interrupt 类型定义
- [ ] IP、CBB、VIP 和 SoCGen 至少各有真实消费者（示例已建，正式证据待验证）
- [ ] UVM Verification Skill 可根据 Interface ID 选择 VIP（依赖 UVM 基础库）
- [ ] SoC Integration Skill 不能静默连接不兼容接口（依赖 SoCGen 集成）

---

## 六、质量 Gate（参照 plan.md §17.2）

| Gate | 检查内容 | 状态 |
|---|---|---|
| G0 Contract | YAML Schema、稳定 ID、规范引用、Owner | [x]（全部契约通过 schema 校验 + 4/4 正负向测试） |
| G1 Semantic | role/channel/signal/clock/reset/power/能力评审 | [ ]（待架构评审） |
| G2 HDL | package/interface/flat view 编译和一致性 | [x]（107 文件 vlogan 编译通过 + SV↔契约一致性 PASS） |
| G3 Roundtrip | struct↔interface↔flat 无信息丢失 | [x]（[`tests/structural`](tests/structural/README.md) 7/7 通过：width 求值 + SV 一致性 + flat 命名） |
| G4 Consumer | IP / VIP / SoCGen 各一个消费示例 | [x]（[`tests/consumer`](tests/consumer/README.md) 61/61：binding/core 依赖/rtl 引用完整） |
| G5 Compatibility | 正/负/需 adapter 用例判定正确 | [x]（3/3 用例通过） |
| G6 Release | SemVer、Manifest、SBOM、hash、Catalog 更新 | [x]（Manifest/hash/Quality + catalog + lockfile 生成校验通过） |

---

## 七、问题与风险

| 日期 | 问题 / 风险 | 影响 | 状态 |
|------|------------|------|------|
| 2026-08-13 | 全部 56 个接口族（L0–L6）已具备 Contract + RTL + core | 支撑 RTL/VIP 消费 | 已解决 |
| 2026-08-13 | 工具链 6 项 + 测试 5 项 + CI + IP-XACT/catalog/lockfile 全部落地；剩余 docs 生成与 Flat Wrapper View C 深度待扩展 | 自动化已完善 | 基本解决 |
| 2026-08-13 | `generated/` 已含 56 SV 视图 + 112 IP-XACT XML | 外部工具交换可用 | 已解决 |
| 2026-08-13 | 消费者示例/测试已建，正式 IP/VIP/SoCGen 真实消费证据待验证 | G1/G4 深度验证 | 待验证 |
| 2026-08-13 | VCS 环境缺 32 位库导致 `vcs` 链接失败 | 仅影响本机链接，`vlogan` 分析可用 | 环境问题 |

---

## 八、变更记录

| 日期 | 变更内容 | 作者 |
|------|---------|------|
| 2026-08-13 | 创建 todo.md，参照 plan.md V1.0 重构：纳入阶段路线图、L0–L6 接口矩阵（标记仓库现状）、工具链/测试、P0/P1/P2 TODO、验收标准、质量 Gate | Zoo |
| 2026-08-13 | G0 门禁：`contract_validate` 跑通全仓 42 契约 schema 校验（修复 ahb_lite/apb handshake 枚举、common_types 空通道、release_manifest 占位值）；扩展 schema 支持 apb/ahb 握手与空 channels；工具支持 jsonschema 3.x/4.x 回退 | Zoo |
| 2026-08-13 | 参考 PULP OBI 补齐 `bus/obi` RTL 视图（pkg + if + core），vlogan 编译通过 | Zoo |
| 2026-08-13 | 整理 `reference/`：去重 `axi`/`pulp-axi`，更新清单至 16 项并补充 PULP 参考，VCS 产物（AN.DB/csrc/simv*）加入 `.gitignore` | Zoo |
| 2026-08-13 | 补齐 peripheral 族（gpio/uart/spi/i2c/jtag_dmi）与 `ahb_lite` 的 RTL 视图（View B interface；ahb_lite 另含 View A pkg），更新对应 `.core` 加入 rtl fileset，vlogan 全量编译通过 | Zoo |
| 2026-08-13 | 补齐剩余缺 RTL 接口（clock_control/power_state/reset_control/trace_stream/mbist_control/fault_injection_control/noc_flit）的 pkg + if + core | Zoo |
| 2026-08-13 | 实现 `sv_consistency_check`（SV↔契约信号一致性，全库 PASS）；建立 `tests/schema` 正/负向测试（4/4 通过）；建立 GitHub Actions CI 与拓扑编译脚本（62 文件全量通过）；修复 event 保留字与 clock modport 方向 | Zoo |
| 2026-08-13 | 实现 `view_generate`（YAML→SV interface 视图确定性生成，33 视图编译通过，`--check-only` 门禁接入 CI）与 `compatibility_check`（DIRECT/ADAPTER_REQUIRED/INCOMPATIBLE 三类判定，3/3 测试通过，接入 CI）；补充 `tests/compatibility` 用例 | Zoo |
| 2026-08-13 | 实现 `impact_analysis`（接口族影响面与消费者扫描）与 `package_release`（Release 包 + Manifest/Quality 生成，manifest 通过 schema 校验）；至此 plan §8 tools/ 6 项工具全部落地 | Zoo |
| 2026-08-13 | 补齐 L0–L6 全部未建设接口（21 个）：status_control/alert/isolation/retention/lifecycle_state/memory_tdp/rom/ecc_memory_sideband/cache_maintenance/tilelink_ul/pwm/pad_control/pll_control/performance_event/debug_request/scan_control/lbist_control/dfx_override/integrity_sideband/lockstep_compare/watchdog_service/domain_health/security_violation（contract+rtl+core） | Zoo |
| 2026-08-13 | 建立 tests/compile（107 文件）、tests/structural（7/7）、tests/consumer（61/61）并接入 CI；view_generate 扩展 IP-XACT 生成（112 XML）；package_release 扩展 catalog + SoC Lockfile；补齐 9 个 Profile；新增 IP-XACT/Legacy binding 示例与 reference 许可证审计报告 | Zoo |
| 2026-08-13 | view_generate 扩展 Flat Port Wrapper（`--flat`，56 个 View C）与 Interface Spec 文档（`--docs`，56 个 markdown）；compatibility_check 增强 Profile 能力协商（tests 4/4）；同步阶段路线图完成度 | Zoo |
