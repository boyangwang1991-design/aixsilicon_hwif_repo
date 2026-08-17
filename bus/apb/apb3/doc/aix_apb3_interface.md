# aix_apb3 接口文档

> `IFC-APB3-001` · `apb` v`1.0.0` · `draft` · Owner: `hw-platform`
>
> 本文档是派生视图（由 `interface-doc-template.md` 展开）。契约 SSOT: [`contract/apb3.interface.yaml`](../contract/apb3.interface.yaml)

## 1. 接口身份

| 项 | 值 |
|---|---|
| Interface ID | `IFC-APB3-001` |
| 接口名 | `aix_apb3` |
| Family | `apb`（版本子目录 `apb3/`） |
| SemVer | `1.0.0` |
| Owner | `hw-platform` |
| Lifecycle | `draft` |

**协议引用**：`AMBA-APB-PROTOCOL`（revision `APB3`，kind `commercial`）
- URL: https://developer.arm.com/Architectures/AMBA
- 备注：AMBA APB3 端点契约（L3）。APB3 相对 APB2 新增 PREADY/PSLVERR（wait state + error 响应）；**不含** APB4 的 PSTRB/PPROT/PWAKEUP。APB3 与 APB4 是独立契约（独立 `name`/VLNV），不共用信号集。

## 2. 角色

| Role | 协议别名 | 说明 |
|---|---|---|
| `initiator` | manager, master | 发起传输方（管理端/主端） |
| `target` | subordinate, slave | 响应传输方（从端/受控端） |

## 3. 参数

| 参数 | 类型 | 默认值 | 约束 | 说明 |
|---|---|---|---|---|
| `ADDR_W` | uint | 32 | min=1 | 地址位宽（字节寻址） |
| `DATA_W` | uint | 32 | min=8, multiple_of=8 | 数据位宽（8 的倍数） |

## 4. 时钟与复位

### 时钟域

| 时钟 | 边沿 | 说明 |
|---|---|---|
| `clk` | rising | 接口采样时钟（APB 所有信号在上升沿采样） |

### 复位域

| 复位 | 极性 | 断言 | 释放 | 同步时钟 |
|---|---|---|---|---|
| `rst_n` | active_low | asynchronous | synchronous | clk |

> 连接责任：master 侧提供 `clk`/`rst_n`，target 侧作为输入接入（参见第 12 节使用示例）。

## 5. 通道与信号

### `apb`（handshake=`apb`，ordering=`in_order`）

信号方向统一记作 `from → to`（HWIF 角色），与协议原生名一致。

| 信号 | 方向 | 位宽 | 必选 | Capability | 语义要点 |
|---|---|---|---|---|---|
| `psel` | initiator → target | 1 | Y | - | SETUP/ACCESS 阶段选择目标 |
| `penable` | initiator → target | 1 | Y | - | ACCESS 阶段指示传输使能 |
| `paddr` | initiator → target | ADDR_W | Y | - | 传输地址（字节） |
| `pwrite` | initiator → target | 1 | Y | - | 1=写，0=读 |
| `pwdata` | initiator → target | DATA_W | Y | - | 写数据 |
| `prdata` | target → initiator | DATA_W | Y | - | 读数据 |
| `pready` | target → initiator | 1 | Y | - | target 完成传输（APB3 新增 wait state 支持） |
| `pslverr` | target → initiator | 1 | Y | - | 1=传输错误（APB3 新增错误响应） |

**协议时序摘要**：
- SETUP：`PSEL` 拉高、`PENABLE` 为低，持续 1 拍；
- ACCESS：`PSEL`+`PENABLE` 均为高，`PREADY`=1 时完成；target 可拉低 `PREADY` 插入 wait state 延长 ACCESS；
- 传输完成条件：`PSEL && PENABLE && PREADY`；
- 错误：ACCESS 完成时 `PSLVERR`=1 表示响应错误。

## 6. 能力（Capabilities）

APB3 严格信号集契约不声明任何可选 capability（`capabilities: []`）。

| Capability | 信号 | 默认 | 协议语义 |
|---|---|---|---|
| （无） | - | - | APB3 契约不携带可选信号；PSTRB/PPROT/PWAKEUP 属 APB4，不在此契约 |

> 若后续需要 APB4 扩展（字节使能/保护/低功耗唤醒），使用独立的 `bus/apb/apb4/` 契约，而非在本契约加 capability。

## 7. 语义与约束

- 传输在 `PSEL && PENABLE && PREADY` 完成；`PSLVERR` 在同一拍有效表示传输失败。
- `PREADY`=0 可插入 wait state（APB3 相对 APB2 的关键增强）。
- 本接口描述端点契约，不描述互联拓扑/仲裁。

## 8. 端点视图（Views）

| 视图 | 类型 | 位置 |
|---|---|---|
| View A (packed struct) | `aix_apb3_pkg.sv` | `rtl/` |
| View B (SV interface) | `aix_apb3_if.sv` | `rtl/` |
| View C (flat wrapper) | `aix_apb3_flat_wrapper.sv` | `generated/apb/` |
| View D (spec md) | `aix_apb3_spec.md` | `generated/docs/apb/` |
| IP-XACT | `aix_apb3_busdef.xml` / `aix_apb3_absdef.xml` | `generated/ipxact/apb/` |

> 所有视图由 `hwif-development-suite` 从 YAML 契约确定性生成；禁止手工修改 generated 视图。

## 9. 配置档案（Profile）

| Profile | 版本 | 能力冻结 | 参数约束 | 适用场景 |
|---|---|---|---|---|
| `apb3_base`（IFC-PROFILE-APB3-BASE-1） | 1.0.0 | （无 capability） | ADDR_W: [32], DATA_W: [8, 16, 32, 64] | APB3 通用基础配置 |

## 10. 绑定（Binding）

| Binding | 目标资产 | kind | 角色映射 | 说明 |
|---|---|---|---|---|
| `bindings/legacy/apb_binding.yaml` | `legacy:apb_bus:1.0.0` | legacy | initiator→master, target→slave | APB3 到历史资产端口名（PSEL/PENABLE/PADDR/PWRITE/PWDATA/PRDATA/PREADY/PSLVERR）的别名映射 |

## 11. 依赖与兼容

**依赖**（Core 依赖，禁止反向依赖 IP/CBB/VIP）：

```text
aix:interface:common → aix:interface:apb3
```

**兼容矩阵**（与消费者接口判定）：

| 消费者接口 | 判定 | 说明 |
|---|---|---|
| `axi` / `axi_lite` | `ADAPTER_REQUIRED` | 跨 AMBA 协议族需桥（AXI↔APB） |
| `bus/apb/apb4`（`aix:interface:apb`） | `ADAPTER_REQUIRED` | APB3↔APB4 信号集不同（PSTRB/PPROT/PWAKEUP 缺失），需适配器补齐可选信号；不可直接连接 |

> 判定由 `hwif-compatibility-check` 输出；adapter 实现不属于本仓库（归 CBB）。

## 12. 使用示例

```verilog
// View B：例化 SV interface（master 侧提供 clk/rst_n）
aix_apb3_if #(
  .ADDR_W (32),
  .DATA_W (32)
) u_apb3 (
  .clk   (clk),
  .rst_n (rst_n)
);

// initiator（master）通过 modport 驱动 PSEL/PENABLE/PADDR/PWRITE/PWDATA，
// target（slave）通过 modport 响应 PRDATA/PREADY/PSLVERR。
```

> 消费者示例仓库：`examples/apb3_target/`（View A：`import aix_apb3_pkg::*`，使用 `apb3_req_t`/`apb3_rsp_t`）。

## 13. 变更记录

| 版本 | 日期 | 变更 |
|---|---|---|
| 1.0.0 | 2026-08-17 | 初始文档化；严格 APB3 信号全集（含 PREADY/PSLVERR，无 APB4 扩展） |

---

> 模板维护说明：
> - 模板存放于 SKILL `references/interface-doc-template.md`；
> - 契约变更（信号/参数/能力）后：重跑 `generate --views doc`，并在本文档相应章节同步；
> - 本文件为派生视图，语义以 `contract/apb3.interface.yaml` 为 SSOT。