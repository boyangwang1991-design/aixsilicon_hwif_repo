# credit_link — 信用链路接口（L3）

flit、credit return、VC、QoS、retry 能力。用于低延迟高带宽链路。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/credit_link.interface.yaml`](contract/credit_link.interface.yaml:1) |
| Basic Profile | [`contract/credit_link_basic.profile.yaml`](contract/credit_link_basic.profile.yaml:1) |
| SV Package | [`rtl/aix_credit_link_pkg.sv`](rtl/aix_credit_link_pkg.sv:1) |
| SV Interface | [`rtl/aix_credit_link_if.sv`](rtl/aix_credit_link_if.sv:1) |
| FuseSoC Core | [`aix_interface_credit_link.core`](aix_interface_credit_link.core:1) |

## 语义要点

- 角色：`initiator` / `target`；
- 信用机制：initiator 持有 credit，发送 flit 消耗 credit，target 返回 credit；
- 能力：`vc`（虚拟通道）、`qos`、`retry`；
- Profile：`credit_link_basic_v1`。
