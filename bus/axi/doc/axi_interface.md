# axi 接口文档

> `IFC-AXI-001` · `axi` v`1.0.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/axi.interface.yaml`](../contract/axi.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-AXI-001` |
| 接口名 | `axi` |
| Family | `axi` |
| SemVer | `1.0.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AMBA-AXI-PROTOCOL`（revision `AXI4`，kind `commercial`）
- URL: https://developer.arm.com/documentation/102202/latest/AXI-protocol-overview
- 备注：点到点接口协议；Crossbar 拓扑不属于本契约

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `initiator` | manager, master | 接口角色（详情见契约） |
| `target` | subordinate, slave | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `ID_W` | uint | 8 | min=1 |  |
| `ADDR_W` | uint | 64 | min=1 |  |
| `DATA_W` | uint | 64 | min=8, multiple_of=8 |  |
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
| `awvalid` | initiator → target | 1 | Y | - | 见契约语义 |
| `awready` | target → initiator | 1 | Y | - | 见契约语义 |
| `awid` | initiator → target | ID_W | Y | - | 见契约语义 |
| `awaddr` | initiator → target | ADDR_W | Y | - | 见契约语义 |
| `awlen` | initiator → target | 8 | Y | - | 见契约语义 |
| `awsize` | initiator → target | 3 | Y | - | 见契约语义 |
| `awburst` | initiator → target | 2 | Y | - | 见契约语义 |
| `awlock` | initiator → target | 1 | Y | - | 见契约语义 |
| `awcache` | initiator → target | 4 | Y | - | 见契约语义 |
| `awprot` | initiator → target | 3 | Y | - | 见契约语义 |
| `awqos` | initiator → target | 4 | Y | - | 见契约语义 |
| `awregion` | initiator → target | 4 | Y | - | 见契约语义 |
| `awatop` | initiator → target | 6 | N | atop | 见契约语义 |
| `awuser` | initiator → target | USER_W | N | user_sideband | 见契约语义 |

### `w`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `wvalid` | initiator → target | 1 | Y | - | 见契约语义 |
| `wready` | target → initiator | 1 | Y | - | 见契约语义 |
| `wdata` | initiator → target | DATA_W | Y | - | 见契约语义 |
| `wstrb` | initiator → target | DATA_W / 8 | Y | - | 见契约语义 |
| `wlast` | initiator → target | 1 | Y | - | 见契约语义 |
| `wuser` | initiator → target | USER_W | N | user_sideband | 见契约语义 |

### `b`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `bvalid` | target → initiator | 1 | Y | - | 见契约语义 |
| `bready` | initiator → target | 1 | Y | - | 见契约语义 |
| `bid` | target → initiator | ID_W | Y | - | 见契约语义 |
| `bresp` | target → initiator | 2 | Y | - | 见契约语义 |
| `buser` | target → initiator | USER_W | N | user_sideband | 见契约语义 |

### `ar`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `arvalid` | initiator → target | 1 | Y | - | 见契约语义 |
| `arready` | target → initiator | 1 | Y | - | 见契约语义 |
| `arid` | initiator → target | ID_W | Y | - | 见契约语义 |
| `araddr` | initiator → target | ADDR_W | Y | - | 见契约语义 |
| `arlen` | initiator → target | 8 | Y | - | 见契约语义 |
| `arsize` | initiator → target | 3 | Y | - | 见契约语义 |
| `arburst` | initiator → target | 2 | Y | - | 见契约语义 |
| `arlock` | initiator → target | 1 | Y | - | 见契约语义 |
| `arcache` | initiator → target | 4 | Y | - | 见契约语义 |
| `arprot` | initiator → target | 3 | Y | - | 见契约语义 |
| `arqos` | initiator → target | 4 | Y | - | 见契约语义 |
| `arregion` | initiator → target | 4 | Y | - | 见契约语义 |
| `aruser` | initiator → target | USER_W | N | user_sideband | 见契约语义 |

### `r`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `rvalid` | target → initiator | 1 | Y | - | 见契约语义 |
| `rready` | initiator → target | 1 | Y | - | 见契约语义 |
| `rid` | target → initiator | ID_W | Y | - | 见契约语义 |
| `rdata` | target → initiator | DATA_W | Y | - | 见契约语义 |
| `rresp` | target → initiator | 2 | Y | - | 见契约语义 |
| `rlast` | target → initiator | 1 | Y | - | 见契约语义 |
| `ruser` | target → initiator | USER_W | N | user_sideband | 见契约语义 |


## 6. 能力（Capabilities）

| `atop` | - | False | 原子操作（AW 通道 ATOP 字段）。 |
| `user_sideband` | - | False |  |
| `exclusive` | - | False | 独占访问支持（Exclusive Access）。 |

## 7. 语义与约束

- **transfer**：`valid && ready`
- **resp_encoding**：`00=OKAY, 01=EXOKAY, 10=SLVERR, 11=DECERR`
- **write_ordering**：`B response follows final w_last`
- **read_ordering**：`R response follows ar`
- **burst_types**：`FIXED=00, INCR=01, WRAP=10`
- **exclusive**：`paired exclusive read/write, EXOKAY on success`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `axi_pkg.sv` | `rtl/` |
| View B (SV interface) | `axi_if.sv` | `rtl/` |
| View C (flat wrapper) | `axi_flat_wrapper.sv` | `generated/axi/` |
| View D (spec md) | `axi_spec.md` | `generated/docs/axi/` |
| IP-XACT | `axi_busdef.xml` / `axi_absdef.xml` | `generated/ipxact/axi/` |

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
aixsilicon:interface:common → aixsilicon:interface:axi
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
axi_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_axi (
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
> - 本文件为派生视图，语义以 `contract/axi.interface.yaml` 为 SSOT。
