# aix_hac_lmem 接口文档

> `IFC-HAC-LMEM-001` · `hac_lmem` v`0.1.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/hac_lmem.interface.yaml`](../contract/hac_lmem.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-HAC-LMEM-001` |
| 接口名 | `aix_hac_lmem` |
| Family | `hac_lmem` |
| SemVer | `0.1.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AIX-HAC-IF-004`（revision `0.1`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `core` | initiator | 接口角色（详情见契约） |
| `lmem` | target, sram_wrapper | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `DATA_W` | uint | 64 | min=8, multiple_of=8 |  |
| `ADDR_W` | uint | 16 | min=1 |  |
| `BANK_W` | uint | 0 | min=0 |  |
| `TAG_W` | uint | 4 | min=0 |  |

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

### `req`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `req_valid` | core → lmem | 1 | Y | - | 见契约语义 |
| `req_ready` | lmem → core | 1 | Y | - | 见契约语义 |
| `write` | core → lmem | 1 | Y | - | 见契约语义 |
| `bank` | core → lmem | BANK_W | N | multi_bank | 见契约语义 |
| `addr` | core → lmem | ADDR_W | Y | - | 见契约语义 |
| `wdata` | core → lmem | DATA_W | Y | - | 见契约语义 |
| `wstrb` | core → lmem | DATA_W/8 | Y | - | 见契约语义 |
| `tag` | core → lmem | TAG_W | N | decoupled | 见契约语义 |

### `rsp`（handshake=`ready_valid`，ordering=`per_tag`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `rsp_valid` | lmem → core | 1 | Y | - | 见契约语义 |
| `rsp_ready` | core → lmem | 1 | Y | - | 见契约语义 |
| `rdata` | lmem → core | DATA_W | Y | - | 见契约语义 |
| `tag` | lmem → core | TAG_W | N | decoupled | 见契约语义 |
| `ecc_corrected` | lmem → core | 1 | N | ecc | 见契约语义 |
| `ecc_uncorrectable` | lmem → core | 1 | N | ecc | 见契约语义 |


## 6. 能力（Capabilities）

| `multi_bank` | - | False |  |
| `decoupled` | - | False |  |
| `ecc` | - | False |  |

## 7. 语义与约束

- **fixed_profile**：`LMEM-FIXED returns in fixed 1 or 2 cycles, tightly coupled single-bank SRAM`
- **decoupled_profile**：`LMEM-DECOUPLED decouples request/response for arbitration, multi-bank, variable latency`
- **no_macro_binding**：`HAC Core must not bind Foundry macro ports directly; LMEM Adapter handles macro adaptation/ECC/repair`
- **sleep_retention_wrapper**：`sleep/retention appear only on the Memory Wrapper side`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_hac_lmem_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_hac_lmem_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_hac_lmem_flat_wrapper.sv` | `generated/hac_lmem/` |
| View D (spec md) | `aix_hac_lmem_spec.md` | `generated/docs/hac_lmem/` |
| IP-XACT | `aix_hac_lmem_busdef.xml` / `aix_hac_lmem_absdef.xml` | `generated/ipxact/hac_lmem/` |

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
aix:interface:common → aix:interface:hac_lmem
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_hac_lmem_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_hac_lmem (
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
> - 本文件为派生视图，语义以 `contract/hac_lmem.interface.yaml` 为 SSOT。
