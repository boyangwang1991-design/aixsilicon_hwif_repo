# apb3 — AMBA APB3 接口（L3）

AMBA APB3 端点契约（`aixsilicon:interface:apb3:1.0.0`）。APB3 相对 APB2 新增 PREADY/PSLVERR
（wait state + 错误响应），不含 APB4 的 PPROT/PSTRB/PWAKEUP。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/apb3.interface.yaml`](contract/apb3.interface.yaml:1) |
| APB3 基础 Profile | [`contract/apb3_base.profile.yaml`](contract/apb3_base.profile.yaml:1) |
| 接口文档 | [`doc/apb3_interface.md`](doc/apb3_interface.md:1) |
| SV Package（View A） | [`rtl/apb3_pkg.sv`](rtl/apb3_pkg.sv:1) |
| SV Interface（View B） | [`rtl/apb3_if.sv`](rtl/apb3_if.sv:1) |
| FuseSoC Core | [`interface_apb3.core`](interface_apb3.core:1) |

## 语义要点

- 角色：`initiator`（manager）/ `target`（subordinate）；
- APB3 信号全集：PSEL/PENABLE/PADDR/PWRITE/PWDATA/PRDATA/PREADY/PSLVERR；
- 传输时序：SETUP（PSEL，无 PENABLE）→ ACCESS（PSEL+PENABLE，PREADY 完成）；
- PREADY=0 可插入 wait state；PSLVERR=1 表示 slave 错误响应；
- 本接口描述端点契约，不描述互联拓扑。

## 依赖

```text
aixsilicon:interface:common → aixsilicon:interface:apb3