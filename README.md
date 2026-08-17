# AIXSILICON HW Interface Repository

> **IP、CBB、VIP 和 SoC Integration 之间统一、可版本化、可机器读取的硬件接口契约中心。**

本仓库（`hw-interfaces` Monorepo）定义接口的**身份、语义、能力与实现视图**，是硬件前端的**接口类型系统、契约系统和兼容性判断系统**。它不实现协议行为（VIP 负责验证），不实现适配逻辑（CBB 负责转换），不决定谁连接谁（SoC Integration 负责实例连接）。

## 1. 建设结论

- **YAML Contract 是接口语义 SSOT**，定义接口事实；
- **SystemVerilog package + packed struct** 是内部 RTL 首选视图（View A）；
- **SystemVerilog interface/modport** 是验证与局部封装视图（View B）；
- **Flattened Port Wrapper** 是 IP 交付与工具兼容视图（View C）；
- **IP-XACT** 是可选的派生交换视图，不取代 YAML；
- **FuseSoC** 负责依赖、编译顺序、fileset 与 target，不承担接口语义建模；
- **协议 SVA/Checker 归 VIP Repo**，**协议桥/CDC/位宽转换归 CBB Repo**。

三条最核心的架构纪律：

1. **接口事实只定义一次**，所有 SV / IP-XACT / 文档 / Binding 视图都从 YAML 派生或接受一致性检查；
2. **Interface Repo 只定义契约**：VIP 负责验证行为、CBB 负责适配实现、SoCGen 负责实例连接；
3. **任何不兼容连接都必须显式失败或选择已认证 Adapter**，绝不允许静默截位、绑常量或改变语义。

## 2. 仓库边界

| 资产 | 归属 |
|---|---|
| Interface YAML Contract / Profile / Compatibility | 本仓库 |
| SV package / packed struct / interface / modport | 本仓库 |
| Flatten / unflatten wrapper 模板 | 本仓库 |
| Clock / Reset / Power / CDC 属性 | 本仓库 |
| VIP Binding Map、IP-XACT 派生视图、FuseSoC Core | 本仓库 |
| AXI/APB Driver、Monitor、Sequence、SVA/Checker | `vip-repo` |
| Bridge、Width/ID/Clock Converter、CDC 同步器、Async FIFO | `cbb-repo` / `hw-techlib` |
| IP Top 端口清单、SoC 实例连接、地址与中断分配 | `ip-repo` / `soc-integration` |
| CSR 寄存器定义 | 所属 IP 的 SystemRDL |

## 3. 仓库结构

```text
hw-interfaces/
├── docs/            # 架构、建模、命名、兼容性、集成指南
├── schema/          # YAML Contract/Profile/Binding/Compatibility/Release Manifest Schema
├── common/          # 公共类型底座（common_types / rtl / core）
├── foundation/      # L0：clock / reset / ready_valid / req_ack / event
├── system/          # L1：interrupt / error_report / clock_control / reset_control / power_state
├── memory/          # L2：reg_native / memory_1rw / memory_1r1w / fifo_push_pop
├── bus/             # L3：apb / axi_lite / axi / axi_stream / ahb_lite / obi
├── link/            # L3：credit_link / packet_stream / noc_flit
├── peripheral/      # L4：uart / spi / i2c / gpio / jtag_dmi
├── dft_debug/       # L5：trace / perf_event / scan / mbist / lbist ...
├── safety_security/ # L6：integrity / safety_event / fault_injection / lockstep ...
├── accelerator/     # L6：hac_if（HAC-CTRL / STREAM / MEM / LMEM / EVENT / MGMT）
├── profiles/        # 组织级 / 项目级 Profile
├── bindings/        # VIP / IP-XACT / Legacy 绑定映射
├── generated/       # 派生视图（禁止手工修改）
├── examples/        # 消费者示例
└── archived/        # 历史 plan.md / todo.md（仅存档，不再维护）
```

> **确定性工具不保存在本仓库**：生成/校验/兼容/影响/打包统一走
> **私有 skill `hwif-development-suite`**（`aixsilicon_skill_repo`，唯一入口 `hwif_tool.py`）。
> 本仓库只存契约 SSOT（`schema/`、`contract/`）+ 生成结果（`generated/`）+ 手写 RTL/SV/`.core`。

## 4. 接口依赖层级

接口 Core **不能反向依赖** 具体 IP、CBB 或 VIP，以防形成依赖环：

```text
aix:interface:common
        ↓
aix:interface:ready_valid / interrupt / memory
        ↓
aix:interface:apb / axi_lite / axi / axi_stream
        ↓
IP / CBB / VIP
        ↓
Subsystem / SoC Top
```

## 5. 快速开始

确定性入口统一在 `hwif-development-suite`（`aixsilicon_skill_repo`）：

```bash
# 套件路径
SUITE_DIR="${SUITE_DIR:-.roo/skills/hwif-development-suite}"

# 校验所有 Contract YAML（Schema + 语义门禁）
uv run python ${SUITE_DIR}/scripts/hwif_tool.py validate --root . [--json=evidence.json]

# 多视图生成 + drift 检查
uv run python ${SUITE_DIR}/scripts/hwif_tool.py generate --root . --views flat,doc,ipxact
uv run python ${SUITE_DIR}/scripts/hwif_tool.py generate --root . --check-only

# 兼容判定 / SV 一致性 / core / package
uv run python ${SUITE_DIR}/scripts/hwif_tool.py compat --a bus/axi/contract/axi.interface.yaml --b bus/apb/apb4/contract/apb.interface.yaml
uv run python ${SUITE_DIR}/scripts/hwif_tool.py consistency --root .
uv run python ${SUITE_DIR}/scripts/hwif_tool.py core --root .
uv run python ${SUITE_DIR}/scripts/hwif_tool.py package --root . --family apb --dry-run

# FuseSoC 直接消费接口 Core
fusesoc core list | grep aix:interface
```

## 6. 文档入口

| 文档 | 路径 |
|---|---|
| HWIF 域总入口（当前设计） | workflow 仓 `docs/hwif/README.md`（+`repo-architecture.md`+`skill.md`） |
| 历史设计/收敛规划（存档） | [`archived/docs/design-reference.md`](archived/docs/design-reference.md)、[`archived/docs/aix-hwif-gen-unified-plan.md`](archived/docs/aix-hwif-gen-unified-plan.md) |
| 架构指南 | [`docs/architecture/README.md`](docs/architecture/README.md:1) |
| 建模指南 | [`docs/modeling-guide/README.md`](docs/modeling-guide/README.md:1) |
| 命名规范 | [`docs/naming-convention/README.md`](docs/naming-convention/README.md:1) |
| 兼容性指南 | [`docs/compatibility-guide/README.md`](docs/compatibility-guide/README.md:1) |
| 集成指南 | [`docs/integration-guide/README.md`](docs/integration-guide/README.md:1) |
| 历史规划（存档） | [`archived/plan.md`](archived/plan.md)、`archived/todo.md` |

## 7. 许可与合规

- 许可证文件见 [`LICENSES/`](LICENSES/README.md:1)；
- 开源引用（PULP AXI、OpenTitan 等）按文件执行 License 审计，参考 `CONTRIBUTING.md`；
- 商业协议规范正文不复制进本仓库，仅记录受控引用。

## 8. 状态

- **准入能力已达**：64 接口 `.core`、62 Contract、18 Profile、56+ 派生视图；validate/generate/consistency/compat/core/package 门禁由 `hwif-development-suite` 唯一入口提供（P1–P4 收敛完成，2026-08-17）。
- 组合优先级、里程碑与任务状态以 workflow 仓 [`docs/todo.md`](../../docs/todo.md) 为准。
