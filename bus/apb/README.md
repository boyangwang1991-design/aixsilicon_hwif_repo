# apb — APB 总线接口（L3）

AMBA APB 端点契约。APB4/APB5 按实际项目版本建立独立 Profile。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/apb.interface.yaml`](contract/apb.interface.yaml:1) |
| APB4 基础 Profile | [`contract/apb4_base.profile.yaml`](contract/apb4_base.profile.yaml:1) |
| SV Package（View A） | [`rtl/aix_apb_pkg.sv`](rtl/aix_apb_pkg.sv:1) |
| SV Interface（View B） | [`rtl/aix_apb_if.sv`](rtl/aix_apb_if.sv:1) |
| FuseSoC Core | [`aix_interface_apb.core`](aix_interface_apb.core:1) |

## 语义要点

- 角色：`initiator`（manager）/ `target`（subordinate）；
- APB4 信号：PSEL/PENABLE/PADDR/PWRITE/PWDATA/PRDATA/PREADY/PSLVERR；
- 可选：PPROT、PSTRB（按 Profile）；
- 本接口描述端点契约，不描述互联拓扑；
- 规范正文不复制，仅记录受控引用。

## 依赖

```text
aix:interface:common → aix:interface:apb
```
