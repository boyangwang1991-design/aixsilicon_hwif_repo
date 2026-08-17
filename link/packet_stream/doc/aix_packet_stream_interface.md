# aix_packet_stream 接口文档

> `IFC-PS-001` · `packet_stream` v`1.0.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/packet_stream.interface.yaml`](../contract/packet_stream.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-PS-001` |
| 接口名 | `aix_packet_stream` |
| Family | `packet_stream` |
| SemVer | `1.0.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-IF-PS-001`（revision `1.0`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `source` | - | 接口角色（详情见契约） |
| `sink` | - | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `DATA_W` | uint | 32 | min=8, multiple_of=8 |  |
| `CHANNEL_W` | uint | 4 | min=1 |  |
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

### `packet`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `valid` | source → sink | 1 | Y | - | 见契约语义 |
| `ready` | sink → source | 1 | Y | - | 见契约语义 |
| `data` | source → sink | DATA_W | Y | - | 见契约语义 |
| `sop` | source → sink | 1 | Y | - | 见契约语义 |
| `eop` | source → sink | 1 | Y | - | 见契约语义 |
| `byte_enable` | source → sink | DATA_W / 8 | N | byte_enable | 见契约语义 |
| `channel` | source → sink | CHANNEL_W | N | channel | 见契约语义 |
| `error` | source → sink | 1 | N | error_sideband | 见契约语义 |
| `user` | source → sink | USER_W | N | user_sideband | 见契约语义 |


## 6. 能力（Capabilities）

| `byte_enable` | - | False |  |
| `channel` | - | False |  |
| `error_sideband` | - | False |  |
| `user_sideband` | - | False |  |

## 7. 语义与约束

- **transfer**：`valid && ready`
- **packet_boundary**：`sop marks start, eop marks end of a packet`
- **error**：`error asserted on final beat marks packet as bad`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_packet_stream_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_packet_stream_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_packet_stream_flat_wrapper.sv` | `generated/packet_stream/` |
| View D (spec md) | `aix_packet_stream_spec.md` | `generated/docs/packet_stream/` |
| IP-XACT | `aix_packet_stream_busdef.xml` / `aix_packet_stream_absdef.xml` | `generated/ipxact/packet_stream/` |

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
aix:interface:common → aix:interface:packet_stream
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_packet_stream_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_packet_stream (
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
> - 本文件为派生视图，语义以 `contract/packet_stream.interface.yaml` 为 SSOT。
