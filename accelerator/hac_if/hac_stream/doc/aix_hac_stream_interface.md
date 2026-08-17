# aix_hac_stream 接口文档

> `IFC-HAC-STRM-001` · `hac_stream` v`0.1.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/hac_stream.interface.yaml`](../contract/hac_stream.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-HAC-STRM-001` |
| 接口名 | `aix_hac_stream` |
| Family | `hac_stream` |
| SemVer | `0.1.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-HAC-IF-002`（revision `0.1`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `producer` | source | 接口角色（详情见契约） |
| `consumer` | sink | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `DATA_W` | uint | 128 | min=8, multiple_of=8 |  |
| `ID_W` | uint | 4 | min=0 |  |
| `USER_W` | uint | 8 | min=0 |  |

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

### `data`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `valid` | producer → consumer | 1 | Y | - | 见契约语义 |
| `ready` | consumer → producer | 1 | Y | - | 见契约语义 |
| `data` | producer → consumer | DATA_W | Y | - | 见契约语义 |
| `keep` | producer → consumer | DATA_W/8 | N | keep | 见契约语义 |
| `last` | producer → consumer | 1 | N | last | 见契约语义 |
| `id` | producer → consumer | ID_W | N | id | 见契约语义 |
| `user` | producer → consumer | USER_W | N | user | 见契约语义 |


## 6. 能力（Capabilities）

| `keep` | - | True |  |
| `last` | - | True |  |
| `id` | - | False |  |
| `user` | - | False |  |

## 7. 语义与约束

- **handshake**：`valid/ready same-cycle handshake`
- **backpressure**：`valid and payload stable while valid=1 && ready=0`
- **keep_byte**：`keep valid per byte; may be trimmed in non-packet mode`
- **last_boundary**：`last marks frame/packet/tensor-tile/task data boundary`
- **id_stream**：`id associates task, virtual channel or data stream`
- **user_documented**：`user carries only protocol-defined sideband fields`
- **no_bidir**：`independent input and output channels; no bidirectional single channel`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_hac_stream_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_hac_stream_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_hac_stream_flat_wrapper.sv` | `generated/hac_stream/` |
| View D (spec md) | `aix_hac_stream_spec.md` | `generated/docs/hac_stream/` |
| IP-XACT | `aix_hac_stream_busdef.xml` / `aix_hac_stream_absdef.xml` | `generated/ipxact/hac_stream/` |

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
aix:interface:common → aix:interface:hac_stream
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_hac_stream_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_hac_stream (
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
> - 本文件为派生视图，语义以 `contract/hac_stream.interface.yaml` 为 SSOT。
