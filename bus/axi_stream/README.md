# axi_stream — AXI-Stream 总线接口（L3）

AMBA AXI-Stream 端点契约，支持 Basic / Packet / Metadata Profile。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/axi_stream.interface.yaml`](contract/axi_stream.interface.yaml:1) |
| Packet Profile | [`contract/axi_stream_packet.profile.yaml`](contract/axi_stream_packet.profile.yaml:1) |
| SV Package（View A） | [`rtl/aix_axi_stream_pkg.sv`](rtl/aix_axi_stream_pkg.sv:1) |
| SV Interface（View B） | [`rtl/aix_axi_stream_if.sv`](rtl/aix_axi_stream_if.sv:1) |
| FuseSoC Core | [`aix_interface_axi_stream.core`](aix_interface_axi_stream.core:1) |

## 语义要点

- 角色：`source` / `sink`；
- 信号：TVALID/TREADY/TDATA/TKEEP/TLAST/TUSER/TID/TDEST；
- 能力：`byte_keep`（TKEEP）、`packet_boundary`（TLAST）、`user_sideband`（TUSER）、`stream_id`（TID/TDEST）；
- Profile：`axi_stream_basic_v1`（无 TKEEP/TLAST）、`axi_stream_packet_v1`（带 TLAST/TKEEP）。

## 依赖

```text
aix:interface:common → aix:interface:axi_stream
```
