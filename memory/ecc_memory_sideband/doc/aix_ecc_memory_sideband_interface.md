# aix_ecc_memory_sideband 接口文档

> `IFC-ECC-SB-001` · `ecc_memory_sideband` v`0.1.0` · `draft` · Owner: `hw-fusa`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/ecc_memory_sideband.interface.yaml`](../contract/ecc_memory_sideband.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-ECC-SB-001` |
| 接口名 | `aix_ecc_memory_sideband` |
| Family | `ecc_memory_sideband` |
| SemVer | `0.1.0` |
| Owner | `hw-fusa` |
| Lifecycle | `draft` |

**协议引用**：`AIX-IF-ECC-SB-001`（revision `0.1`，kind `internal`）
- URL: -
- 备注：-

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `requester` | - | 接口角色（详情见契约） |
| `memory` | - | 接口角色（详情见契约） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `SYNDROME_W` | uint | 8 | min=1 |  |

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

### `ecc`（handshake=`ready_valid`，ordering=`in_order`）

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `ecc_valid` | memory → requester | 1 | Y | - | 见契约语义 |
| `ecc_ready` | requester → memory | 1 | Y | - | 见契约语义 |
| `ecc_corrected` | memory → requester | 1 | Y | - | 见契约语义 |
| `ecc_uncorrectable` | memory → requester | 1 | Y | - | 见契约语义 |
| `ecc_syndrome` | memory → requester | SYNDROME_W | Y | - | 见契约语义 |
| `ecc_inject` | requester → memory | 1 | N | injection | 见契约语义 |


## 6. 能力（Capabilities）

| `injection` | - | False |  |

## 7. 语义与约束

- **ecc_events**：`corrected / uncorrectable / syndrome sideband`

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_ecc_memory_sideband_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_ecc_memory_sideband_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_ecc_memory_sideband_flat_wrapper.sv` | `generated/ecc_memory_sideband/` |
| View D (spec md) | `aix_ecc_memory_sideband_spec.md` | `generated/docs/ecc_memory_sideband/` |
| IP-XACT | `aix_ecc_memory_sideband_busdef.xml` / `aix_ecc_memory_sideband_absdef.xml` | `generated/ipxact/ecc_memory_sideband/` |

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
aix:interface:common → aix:interface:ecc_memory_sideband
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `（待补）` | - | - |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_ecc_memory_sideband_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_aix_ecc_memory_sideband (
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
> - 本文件为派生视图，语义以 `contract/ecc_memory_sideband.interface.yaml` 为 SSOT。
