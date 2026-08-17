# apb — APB 总线接口族（L3）

AMBA APB 端点契约族。**族目录按协议版本分子目录**，每个版本目录是独立可交付单元
（契约 + Profile + RTL + 文档 + `.core`）。

## 版本目录

| 版本子目录 | 协议 | 状态 | 说明 |
|---|---|---|---|
| [`apb3/`](apb3/README.md) | AMBA APB3 | 可用（draft） | 严格 APB3：PSEL/PENABLE/PADDR/PWRITE/PWDATA/PRDATA/PREADY/PSLVERR，无 PSTRB/PPROT/PWAKEUP；`aix:interface:apb3:1.0.0` |
| [`apb4/`](apb4/README.md) | AMBA APB4 | 可用（draft） | 在 APB3 基础上新增 PREADY/PSLVERR/PPROT/PSTRB/PWAKEUP；`aix:interface:apb:1.0.0` |

> 版本差异按协议版本建立**独立契约**（因为 APB3 与 APB4 的必选信号集是硬差异，
> 无法仅靠 Profile capability 冻结表达），而不是在同一个契约里加开关。
> APB3 与 APB4 用不同 `name`（`aix_apb3` vs `aix_apb`）与不同 VLNV（`aix:interface:apb3` vs `aix:interface:apb`）区分。

## 族级约定

- `family: apb`（所有版本共用），VLNV 前缀 `aix:interface:apb3` / `aix:interface:apb`；
- 各版本子目录独占 `contract/`、`rtl/`、`doc/` 与各自 `aix_interface_apb*.core`；
- 派生视图（`generated/apb/`）按 family 统一输出，不按版本分目录；
- 消费者通过 `.core` VLNV + `semantic_version` 锁定版本。

## 依赖

```text
aix:interface:common → aix:interface:apb3
aix:interface:common → aix:interface:apb
