# aix_hac_ctrl 接口文档

> `IFC-HAC-CTRL-001` · `hac_ctrl` v`0.1.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/hac_ctrl.interface.yaml`](../contract/hac_ctrl.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-HAC-CTRL-001` |
| 接口名 | `aix_hac_ctrl` |
| Family | `hac_ctrl` |
| SemVer | `0.1.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-HAC-IF-001`（revision `0.1`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `core` | target, hac_core | 接口角色（详情见契约） |
| `shell` | initiator, hac_shell | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `JOB_ID_W` | uint | 8 | min=0 |  |
| `OPCODE_W` | uint | 8 | min=1 |  |
| `ADDR_W` | uint | 64 | min=1 |  |
| `FLAGS_W` | uint | 16 | min=0 |  |
| `STATUS_W` | uint | 16 | min=1 |  |

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

### `cmd`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `cmd_valid` | shell → core | 1 | Y | - | 见契约语义 |
| `cmd_ready` | core → shell | 1 | Y | - | 见契约语义 |
| `cmd_job_id` | shell → core | JOB_ID_W | Y | - | 见契约语义 |
| `cmd_opcode` | shell → core | OPCODE_W | Y | - | 见契约语义 |
| `cmd_desc_addr` | shell → core | ADDR_W | Y | - | 见契约语义 |
| `cmd_flags` | shell → core | FLAGS_W | N | cmd_flags | 见契约语义 |

### `cpl`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `cpl_valid` | core → shell | 1 | Y | - | 见契约语义 |
| `cpl_ready` | shell → core | 1 | Y | - | 见契约语义 |
| `cpl_job_id` | core → shell | JOB_ID_W | Y | - | 见契约语义 |
| `cpl_status` | core → shell | STATUS_W | Y | - | 见契约语义 |

### `cancel`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `cancel_valid` | shell → core | 1 | N | cancel | 见契约语义 |
| `cancel_ready` | core → shell | 1 | N | cancel | 见契约语义 |
| `cancel_job_id` | shell → core | JOB_ID_W | N | cancel | 见契约语义 |

### `status`（handshake=`none`，ordering=`-`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `busy` | core → shell | 1 | Y | - | 见契约语义 |
| `idle` | core → shell | 1 | Y | - | 见契约语义 |
| `quiescent` | core → shell | 1 | Y | - | 见契约语义 |


## 6. 能力（Capabilities）

| `cancel` | - | False |  |
| `cmd_flags` | - | True |  |

## 7. 语义与约束

- **cmd_accept**：`command accepted when cmd_valid && cmd_ready`
- **cmd_stable**：`all command payload stable while cmd_valid=1 && cmd_ready=0`
- **one_completion**：`each accepted job produces exactly one completion unless reset-aborted`
- **job_id_unique**：`job_id unique within outstanding job set`
- **cpl_stable**：`completion payload stable while cpl_valid=1 && cpl_ready=0`
- **idle_vs_quiescent**：`idle means no active compute; quiescent additionally means no outstanding memory/stream/event`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_hac_ctrl_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_hac_ctrl_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_hac_ctrl_flat_wrapper.sv` | `generated/hac_ctrl/` |
| View D (spec md) | `aix_hac_ctrl_spec.md` | `generated/docs/hac_ctrl/` |
| IP-XACT | `aix_hac_ctrl_busdef.xml` / `aix_hac_ctrl_absdef.xml` | `generated/ipxact/hac_ctrl/` |

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
aix:interface:common → aix:interface:hac_ctrl
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_hac_ctrl_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_hac_ctrl (
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
> - 本文件为派生视图，语义以 `contract/hac_ctrl.interface.yaml` 为 SSOT。
