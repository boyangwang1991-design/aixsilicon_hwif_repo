# reg_native — 简化寄存器接口（L2）

统一简化 CSR request/response，含 byte enable 与 error。语义参考 PULP Register Interface。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/reg_native.interface.yaml`](contract/reg_native.interface.yaml:1) |
| SV Package（req/rsp struct，View A） | [`rtl/reg_native_pkg.sv`](rtl/reg_native_pkg.sv:1) |
| SV Interface（View B） | [`rtl/reg_native_if.sv`](rtl/reg_native_if.sv:1) |
| FuseSoC Core | [`interface_reg_native.core`](interface_reg_native.core:1) |

## 语义要点

- 角色：`initiator` / `target`；
- request：addr、wdata、we、byte enable、valid；
- response：rdata、err、ready；
- AXI/APB → reg_native 的 adapter 代码归 CBB，不在此实现。

## 依赖

```text
aixsilicon:interface:common → aixsilicon:interface:reg_native
```
