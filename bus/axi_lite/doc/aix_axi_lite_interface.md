# aix_axi_lite 接口文档

> `IFC-AXIL-001` · `axi_lite` v`1.0.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/axi_lite.interface.yaml`](../contract/axi_lite.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-AXIL-001` |
| 接口名 | `aix_axi_lite` |
| Family | `axi_lite` |
| SemVer | `1.0.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AMBA-AXI-PROTOCOL`（revision `AXI4-Lite`，kind `commercial`）
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
| `DATA_W` | uint | 32 | min=32, multiple_of=32 |  |
| `USER_W` | uint | 1 | min=1 |  |

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

### `aw`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `aw_valid` | initiator → target | 1 | Y | - | 见契约语义 |
| `aw_ready` | target → initiator | 1 | Y | - | 见契约语义 |
| `aw_addr` | initiator → target | ADDR_W | Y | - | 见契约语义 |
| `aw_prot` | initiator → target | 3 | N | protection | 见契约语义 |
| `aw_user` | initiator → target | USER_W | N | user_sideband | 见契约语义 |

### `w`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `w_valid` | initiator → target | 1 | Y | - | 见契约语义 |
| `w_ready` | target → initiator | 1 | Y | - | 见契约语义 |
| `w_data` | initiator → target | DATA_W | Y | - | 见契约语义 |
| `w_strb` | initiator → target | DATA_W / 8 | Y | - | 见契约语义 |
| `w_user` | initiator → target | USER_W | N | user_sideband | 见契约语义 |

### `b`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `b_valid` | target → initiator | 1 | Y | - | 见契约语义 |
| `b_ready` | initiator → target | 1 | Y | - | 见契约语义 |
| `b_resp` | target → initiator | 2 | Y | - | 见契约语义 |
| `b_user` | target → initiator | USER_W | N | user_sideband | 见契约语义 |

### `ar`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `ar_valid` | initiator → target | 1 | Y | - | 见契约语义 |
| `ar_ready` | target → initiator | 1 | Y | - | 见契约语义 |
| `ar_addr` | initiator → target | ADDR_W | Y | - | 见契约语义 |
| `ar_prot` | initiator → target | 3 | N | protection | 见契约语义 |
| `ar_user` | initiator → target | USER_W | N | user_sideband | 见契约语义 |

### `r`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `r_valid` | target → initiator | 1 | Y | - | 见契约语义 |
| `r_ready` | initiator → target | 1 | Y | - | 见契约语义 |
| `r_data` | target → initiator | DATA_W | Y | - | 见契约语义 |
| `r_resp` | target → initiator | 2 | Y | - | 见契约语义 |
| `r_user` | target → initiator | USER_W | N | user_sideband | 见契约语义 |


## 6. 能力（Capabilities）

| `protection` | - | False |  |
| `user_sideband` | - | False |  |

## 7. 语义与约束

- **transfer**：`valid && ready`
- **single_beat_only**：`True`
- **resp_encoding**：`00=OKAY, 10=SLVERR, 11=DECERR`
- **write_ordering**：`B response follows W data`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_axi_lite_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_axi_lite_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_axi_lite_flat_wrapper.sv` | `generated/axi_lite/` |
| View D (spec md) | `aix_axi_lite_spec.md` | `generated/docs/axi_lite/` |
| IP-XACT | `aix_axi_lite_busdef.xml` / `aix_axi_lite_absdef.xml` | `generated/ipxact/axi_lite/` |

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
aix:interface:common → aix:interface:axi_lite
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_axi_lite_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_axi_lite (
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
> - 本文件为派生视图，语义以 `contract/axi_lite.interface.yaml` 为 SSOT。
