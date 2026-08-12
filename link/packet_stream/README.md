# packet_stream — 包流接口（L3）

SOP/EOP/byte enable/channel/error。用于数据包级流接口（区别于 flit 级 credit_link）。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/packet_stream.interface.yaml`](contract/packet_stream.interface.yaml:1) |
| SV Package | [`rtl/aix_packet_stream_pkg.sv`](rtl/aix_packet_stream_pkg.sv:1) |
| SV Interface | [`rtl/aix_packet_stream_if.sv`](rtl/aix_packet_stream_if.sv:1) |
| FuseSoC Core | [`aix_interface_packet_stream.core`](aix_interface_packet_stream.core:1) |

## 语义要点

- 角色：`source` / `sink`；
- 信号：sop/eop/data/valid/ready、可选 channel/error/user；
- 能力：`byte_enable`、`channel`、`error_sideband`、`user_sideband`；
- 与 ready_valid 族类似但增加包边界与错误语义。
