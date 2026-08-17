# apb4 — AMBA APB4 接口（L3）

AMBA APB4 端点契约（`aix:interface:apb:1.0.0`）。API4 相对 APB3 新增 PREADY/PSLVERR/PPROT/PSTRB/PWAKEUP。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/apb.interface.yaml`](contract/apb.interface.yaml:1) |
| APB4 基础 Profile | [`contract/apb4_base.profile.yaml`](contract/apb4_base.profile.yaml:1) |
| APB CSR Profile | [`contract/apb_csr_v1.profile.yaml`](contract/apb_csr_v1.profile.yaml:1) |
| 接口文档 | [`doc/aix_apb_interface.md`](doc/aix_apb_interface.md:1) |
| SV Package（View A） | [`rtl/aix_apb_pkg.sv`](rtl/aix_apb_pkg.sv:1) |
| SV Interface（View B） | [`rtl/aix_apb_if.sv`](rtl/aix_apb_if.sv:1) |
| FuseSoC Core | [`aix_interface_apb.core`](aix_interface_apb.core:1) |

## 语义要点

- 角色：`initiator`（manager）/ `target`（subordinate）；
- APB4 信号：PSEL/PENABLE/PADDR/PWRITE/PWDATA/PRDATA/PREADY/PSLVERR；
- 可选：PPROT、PSTRB、PWAKEUP（按 Profile capability）；
- 传输时序：SETUP（PSEL，无 PENABLE）→ ACCESS（PSEL+PENABLE，PREADY 完成）；
- 本接口描述端点契约，不描述互联拓扑。

## 依赖

```text
aix:interface:common → aix:interface:apb