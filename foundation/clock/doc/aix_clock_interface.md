# aix_clock 接口文档

> `IFC-CLK-001` · `clock` v`1.0.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/clock.interface.yaml`](../contract/clock.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-CLK-001` |
| 接口名 | `aix_clock` |
| Family | `clock` |
| SemVer | `1.0.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-IF-CLK-001`（revision `1.0`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `controller` | source | 接口角色（详情见契约） |
| `endpoint` | destination | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `FREQ_HZ` | uint | 0 | min=0 | 标称频率（0 表示未约束/由上层决定）。 |

## 4. 时钟与复位

### 时钟域

| 时钟 | 边沿 | 说明 |
|---|---|---|
| `clk` | rising | 接口采样时钟 |

### 复位域

| 复位 | 极性 | 断言 | 释放 | 同步时钟 |
|---|---|---|---|---|
| `-` | - | - | - | - |

## 5. 通道与信号

### `clock_line`（handshake=`none`，ordering=`-`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `clk` | controller → endpoint | 1 | Y | - | 见契约语义 |
| `clk_en` | controller → endpoint | 1 | N | gating | 见契约语义 |
| `clk_gen` | controller → endpoint | 1 | N | derived_clock | 见契约语义 |


## 6. 能力（Capabilities）

| `gating` | - | False |  |
| `derived_clock` | - | False |  |

## 7. 语义与约束

- **frequency_hz**：`FREQ_HZ`
- **gating_off_state**：`clock held at inactive level`
- **derived_clock_source**：`declared via clk_gen`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_clock_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_clock_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_clock_flat_wrapper.sv` | `generated/clock/` |
| View D (spec md) | `aix_clock_spec.md` | `generated/docs/clock/` |
| IP-XACT | `aix_clock_busdef.xml` / `aix_clock_absdef.xml` | `generated/ipxact/clock/` |

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
aix:interface:common → aix:interface:clock
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_clock_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_clock (
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
> - 本文件为派生视图，语义以 `contract/clock.interface.yaml` 为 SSOT。
