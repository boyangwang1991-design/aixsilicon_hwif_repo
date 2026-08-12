# axi_lite — AXI4-Lite 总线接口（L3）

AMBA AXI4-Lite 端点契约。AXI4-Lite 基础 Profile，可选 USER/PROT。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/axi_lite.interface.yaml`](contract/axi_lite.interface.yaml:1) |
| AXI4-Lite CSR Profile | [`contract/axi_lite_csr.profile.yaml`](contract/axi_lite_csr.profile.yaml:1) |
| SV Package（View A） | [`rtl/aix_axi_lite_pkg.sv`](rtl/aix_axi_lite_pkg.sv:1) |
| SV Interface（View B） | [`rtl/aix_axi_lite_if.sv`](rtl/aix_axi_lite_if.sv:1) |
| FuseSoC Core | [`aix_interface_axi_lite.core`](aix_interface_axi_lite.core:1) |

## 语义要点

- 角色：`initiator` / `target`；
- 五个通道：AW / W / B / AR / R；
- 能力：`write_strobe`（WSTRB 必选于 AXI4-Lite）、`user_sideband`（AWUSER/WUSER/BUSER/ARUSER/RUSER）、`protection`（PROT）；
- AXI4-Lite 为单拍事务，不支持 burst/outstanding 语义（AXI4 才支持）；
- 本接口只定义端点契约，Crossbar 拓扑归互联实现。

## 依赖

```text
aix:interface:common → aix:interface:axi_lite
```
