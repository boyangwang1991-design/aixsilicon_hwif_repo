# aix_hac_mgmt 接口文档

> `IFC-HAC-MGMT-001` · `hac_mgmt` v`0.1.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/hac_mgmt.interface.yaml`](../contract/hac_mgmt.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-HAC-MGMT-001` |
| 接口名 | `aix_hac_mgmt` |
| Family | `hac_mgmt` |
| SemVer | `0.1.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-HAC-IF-006`（revision `0.1`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `shell` | manager, hac_shell | 接口角色（详情见契约） |
| `core` | hac_core | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `（无）` | - | - | - | - |

## 4. 时钟与复位

### 时钟域

| 时钟 | 边沿 | 说明 |
|---|---|---|
| `clk` | rising | 接口采样时钟 |

### 复位域

| 复位 | 极性 | 断言 | 释放 | 同步时钟 |
|---|---|---|---|---|
| `rst_n` | active_low | asynchronous | synchronous | clk |

## 5. 通道与信号

### `reset_ctrl`（handshake=`req_ack`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `reset_req` | shell → core | 1 | Y | - | 见契约语义 |
| `reset_ack` | core → shell | 1 | Y | - | 见契约语义 |
| `drain_req` | shell → core | 1 | N | drain | 见契约语义 |
| `drain_ack` | core → shell | 1 | N | drain | 见契约语义 |
| `isolate_req` | shell → core | 1 | N | isolation | 见契约语义 |
| `isolate_ack` | core → shell | 1 | N | isolation | 见契约语义 |

### `status`（handshake=`none`，ordering=`-`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `quiescent` | core → shell | 1 | Y | - | 见契约语义 |
| `idle` | core → shell | 1 | Y | - | 见契约语义 |
| `clock_gate_ok` | core → shell | 1 | N | clock_gating | 见契约语义 |
| `fatal_state` | core → shell | 1 | Y | - | 见契约语义 |


## 6. 能力（Capabilities）

| `drain` | - | True |  |
| `isolation` | - | False |  |
| `clock_gating` | - | True |  |

## 7. 语义与约束

- **drain_flow**：`drain_req stops new job acceptance; core returns quiescent then drain_ack`
- **soft_reset_flow**：`reset_req after drain; reset_ack confirms safe reset`
- **quiescent_safe**：`quiescent indicates safe to gate clock / power off`
- **fatal_system_recovery**：`fatal_state requires system-level recovery`
- **low_power**：`support idle indication, clock-gate indication, retention capability, transaction drain, wake source, isolation`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_hac_mgmt_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_hac_mgmt_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_hac_mgmt_flat_wrapper.sv` | `generated/hac_mgmt/` |
| View D (spec md) | `aix_hac_mgmt_spec.md` | `generated/docs/hac_mgmt/` |
| IP-XACT | `aix_hac_mgmt_busdef.xml` / `aix_hac_mgmt_absdef.xml` | `generated/ipxact/hac_mgmt/` |

> 所有视图由 `hwif-development-suite` 从 YAML 契约确定性生成；禁止手工修改 generated 视图。

## 9. 配置档案（Profile）

| Profile | 版本 | 能力冻结 | 参数约束 | 适用场景 |
|---|---|---|---|---|
| `（待补）` | - | - | - | - |

## 10. 绑定（Binding）

| Binding | 目标资产 | kind | 角色映射 | 说明 |
|---|---|---|---|---|
| `（待补）` | - | - | - | - |

## 11. 依赖与兼容

**依赖**（Core 依赖，禁止反向依赖 IP/CBB/VIP）：

```text
aix:interface:common → aix:interface:hac_mgmt
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_hac_mgmt_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_hac_mgmt (
  .clk   (clk),
  .rst_n (rst_n)
);
```

## 13. 变更记录

| 版本 | 日期 | 变更 |
|---|---|---|
| 0.1.0 | 2026-08-17 | 初始文档化（scaffold 批量生成骨架） |

---

> 模板维护说明：
> - 模板存放于 SKILL `references/interface-doc-template.md`；
> - 契约变更（信号/参数/能力）后：重跑 `generate --views doc`，并在本文档相应章节同步；
> - 本文件为派生视图，语义以 `contract/hac_mgmt.interface.yaml` 为 SSOT。
