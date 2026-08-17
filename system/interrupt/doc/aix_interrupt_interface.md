# aix_interrupt 接口文档

> `IFC-INT-001` · `interrupt` v`1.0.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/interrupt.interface.yaml`](../contract/interrupt.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-INT-001` |
| 接口名 | `aix_interrupt` |
| Family | `interrupt` |
| SemVer | `1.0.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-IF-INT-001`（revision `1.0`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `source` | sender, interrupt_source | 接口角色（详情见契约） |
| `receiver` | target, interrupt_receiver | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `WIDTH` | uint | 1 | min=1 | 中断向量宽度（多中断聚合）。 |

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

### `interrupt_line`（handshake=`none`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `irq` | source → receiver | WIDTH | Y | - | 见契约语义 |
| `irq_ack` | receiver → source | WIDTH | N | acknowledged | 见契约语义 |
| `irq_polarity` | source → receiver | WIDTH | N | polarity_config | 见契约语义 |


## 6. 能力（Capabilities）

| `level` | - | False | level 型中断（保持直到被处理）。 |
| `pulse` | - | False | pulse 型中断（单周期脉冲）。 |
| `vector` | - | False | 支持多比特向量中断。 |
| `acknowledged` | - | False | 提供 irq_ack 应答信号。 |
| `polarity_config` | - | False | 可配置中断极性。 |

## 7. 语义与约束

- **level_assertion**：`level held high/low until handled or acknowledged`
- **pulse_width**：`single cycle`
- **vector_bit**：`each bit is an independent interrupt`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_interrupt_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_interrupt_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_interrupt_flat_wrapper.sv` | `generated/interrupt/` |
| View D (spec md) | `aix_interrupt_spec.md` | `generated/docs/interrupt/` |
| IP-XACT | `aix_interrupt_busdef.xml` / `aix_interrupt_absdef.xml` | `generated/ipxact/interrupt/` |

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
aix:interface:common → aix:interface:interrupt
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_interrupt_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_interrupt (
  .clk   (clk),
  .rst_n (rst_n)
);
```

## 13. 变更记录

| 版本 | 日期 | 变更 |
|---|---|---|
| 1.0.0 | 2026-08-17 | 初始文档化（scaffold 批量生成骨架） |

---

> 模板维护说明：
> - 模板存放于 SKILL `references/interface-doc-template.md`；
> - 契约变更（信号/参数/能力）后：重跑 `generate --views doc`，并在本文档相应章节同步；
> - 本文件为派生视图，语义以 `contract/interrupt.interface.yaml` 为 SSOT。
