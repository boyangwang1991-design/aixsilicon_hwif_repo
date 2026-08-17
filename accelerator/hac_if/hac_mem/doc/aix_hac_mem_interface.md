# aix_hac_mem 接口文档

> `IFC-HAC-MEM-001` · `hac_mem` v`0.1.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/hac_mem.interface.yaml`](../contract/hac_mem.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-HAC-MEM-001` |
| 接口名 | `aix_hac_mem` |
| Family | `hac_mem` |
| SemVer | `0.1.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-HAC-IF-003`（revision `0.1`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `core` | initiator, hac_core | 接口角色（详情见契约） |
| `adapter` | target, hac_shell | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `ADDR_W` | uint | 64 | min=1 |  |
| `DATA_W` | uint | 128 | min=8, multiple_of=8 |  |
| `LEN_W` | uint | 16 | min=1 |  |
| `TAG_W` | uint | 6 | min=1 |  |
| `JOB_ID_W` | uint | 8 | min=0 |  |
| `ATTR_W` | uint | 8 | min=0 |  |

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

### `read_req`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `req_valid` | core → adapter | 1 | Y | - | 见契约语义 |
| `req_ready` | adapter → core | 1 | Y | - | 见契约语义 |
| `req_opcode` | core → adapter | 3 | Y | - | 见契约语义 |
| `req_addr` | core → adapter | ADDR_W | Y | - | 见契约语义 |
| `req_len` | core → adapter | LEN_W | Y | - | 见契约语义 |
| `req_tag` | core → adapter | TAG_W | Y | - | 见契约语义 |
| `req_job_id` | core → adapter | JOB_ID_W | N | job_id | 见契约语义 |
| `req_attr` | core → adapter | ATTR_W | N | attr | 见契约语义 |

### `read_rsp`（handshake=`ready_valid`，ordering=`per_tag`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `rsp_valid` | adapter → core | 1 | Y | - | 见契约语义 |
| `rsp_ready` | core → adapter | 1 | Y | - | 见契约语义 |
| `rsp_data` | adapter → core | DATA_W | Y | - | 见契约语义 |
| `rsp_tag` | adapter → core | TAG_W | Y | - | 见契约语义 |
| `rsp_last` | adapter → core | 1 | Y | - | 见契约语义 |
| `rsp_status` | adapter → core | 4 | Y | - | 见契约语义 |

### `write_req`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `wreq_valid` | core → adapter | 1 | Y | - | 见契约语义 |
| `wreq_ready` | adapter → core | 1 | Y | - | 见契约语义 |
| `wreq_opcode` | core → adapter | 3 | Y | - | 见契约语义 |
| `wreq_addr` | core → adapter | ADDR_W | Y | - | 见契约语义 |
| `wreq_len` | core → adapter | LEN_W | Y | - | 见契约语义 |
| `wreq_tag` | core → adapter | TAG_W | Y | - | 见契约语义 |
| `wreq_last` | core → adapter | 1 | Y | - | 见契约语义 |
| `wdata` | core → adapter | DATA_W | N | data_with_req | 见契约语义 |
| `wstrb` | core → adapter | DATA_W/8 | N | data_with_req | 见契约语义 |

### `write_rsp`（handshake=`ready_valid`，ordering=`per_tag`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `wrsp_valid` | adapter → core | 1 | Y | - | 见契约语义 |
| `wrsp_ready` | core → adapter | 1 | Y | - | 见契约语义 |
| `wrsp_tag` | adapter → core | TAG_W | Y | - | 见契约语义 |
| `wrsp_status` | adapter → core | 4 | Y | - | 见契约语义 |


## 6. 能力（Capabilities）

| `job_id` | - | False |  |
| `attr` | - | True |  |
| `data_with_req` | - | True |  |
| `out_of_order` | - | False |  |
| `unaligned_access` | - | False |  |

## 7. 语义与约束

- **byte_addressing**：`address is byte addressed`
- **len_bytes**：`len_bytes is total valid bytes of the request`
- **tag_unique**：`same tag must not be reused before completion`
- **rsp_ooo**：`responses of different tags may be out of order`
- **rsp_in_order_per_tag**：`responses within same tag must stay in order`
- **wdata_after_req**：`write data must not precede accepted write request unless explicitly allowed`
- **core_abstract_status**：`core sees abstract status only, never raw AXI BRESP/RRESP`
- **partial_completion**：`partial completion must define committed range and recovery policy`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_hac_mem_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_hac_mem_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_hac_mem_flat_wrapper.sv` | `generated/hac_mem/` |
| View D (spec md) | `aix_hac_mem_spec.md` | `generated/docs/hac_mem/` |
| IP-XACT | `aix_hac_mem_busdef.xml` / `aix_hac_mem_absdef.xml` | `generated/ipxact/hac_mem/` |

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
aix:interface:common → aix:interface:hac_mem
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_hac_mem_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_hac_mem (
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
> - 本文件为派生视图，语义以 `contract/hac_mem.interface.yaml` 为 SSOT。
