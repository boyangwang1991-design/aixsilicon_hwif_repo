# apb — APB 总线接口族（L3）

AMBA APB 端点契约族。**族目录按协议版本分子目录**，每个版本目录是独立可交付单元
（契约 + Profile + RTL + 文档 + `.core`）。

## 版本目录

| 版本子目录 | 协议 | 状态 | 说明 |
|---|---|---|---|
| [`apb4/`](apb4/README.md) | AMBA APB4 | 可用（draft） | 含 PREADY/PSLVERR/PPROT/PSTRB/PWAKEUP；`aix:interface:apb:1.0.0` |
| `apb3/` | AMBA APB3 | **预留**（未创建） | 无 PREADY/PSLVERR 等扩展；需要时新建独立契约（family=apb, name=对应接口名, revision=APB3） |

> 版本差异按协议版本建立**独立契约**（因为 APB3 与 APB4 的必选信号集是硬差异，
> 无法仅靠 Profile capability 冻结表达），而不是在同一个契约里加开关。

## 族级约定

- `family: apb`（所有版本共用），VLNV 前缀 `aix:interface:apb`；
- 各版本子目录独占 `contract/`、`rtl/`、`doc/` 与 `aix_interface_apb.core`；
- 派生视图（`generated/apb/`）按 family 统一输出，不按版本分目录；
- 消费者通过 `.core` VLNV + `semantic_version` 锁定版本。

## 依赖

```text
aix:interface:common → aix:interface:apb
