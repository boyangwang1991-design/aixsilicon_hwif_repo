# aix_ahb_lite 接口文档

> `IFC-AHB-001` · `ahb_lite` v`0.1.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/ahb_lite.interface.yaml`](../contract/ahb_lite.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-AHB-001` |
| 接口名 | `aix_ahb_lite` |
| Family | `ahb_lite` |
| SemVer | `0.1.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AMBA-AHB-PROTOCOL`（revision `AHB-Lite`，kind `commercial`）
- URL: https://developer.arm.com/Architectures/AMBA
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `initiator` | manager, master | 接口角色（详情见契约） |
| `target` | subordinate, slave | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `ADDR_W` | uint | 32 | min=1 |  |
| `DATA_W` | uint | 32 | min=8, multiple_of=8 |  |

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

### `ahb`（handshake=`ahb`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `haddr` | initiator → target | ADDR_W | Y | - | 见契约语义 |
| `hwrite` | initiator → target | 1 | Y | - | 见契约语义 |
| `htrans` | initiator → target | 2 | Y | - | 见契约语义 |
| `hsize` | initiator → target | 3 | Y | - | 见契约语义 |
| `hburst` | initiator → target | 3 | Y | - | 见契约语义 |
| `hprot` | initiator → target | 4 | Y | - | 见契约语义 |
| `hwdata` | initiator → target | DATA_W | Y | - | 见契约语义 |
| `hready_in` | target → initiator | 1 | Y | - | 见契约语义 |
| `hresp` | target → initiator | 1 | Y | - | 见契约语义 |
| `hrdata` | target → initiator | DATA_W | Y | - | 见契约语义 |
| `hready` | target → initiator | 1 | Y | - | 见契约语义 |


## 6. 能力（Capabilities）

| `（无）` | - | - | - |

## 7. 语义与约束

- **pipelined**：`address phase and data phase overlap`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_ahb_lite_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_ahb_lite_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_ahb_lite_flat_wrapper.sv` | `generated/ahb_lite/` |
| View D (spec md) | `aix_ahb_lite_spec.md` | `generated/docs/ahb_lite/` |
| IP-XACT | `aix_ahb_lite_busdef.xml` / `aix_ahb_lite_absdef.xml` | `generated/ipxact/ahb_lite/` |

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
aix:interface:common → aix:interface:ahb_lite
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_ahb_lite_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_ahb_lite (
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
> - 本文件为派生视图，语义以 `contract/ahb_lite.interface.yaml` 为 SSOT。
