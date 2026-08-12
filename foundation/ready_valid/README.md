# ready_valid — 就绪/有效流接口（L0）

最基础的流式握手接口族，广泛用于内部数据通路与打包接口底座。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/ready_valid.interface.yaml`](contract/ready_valid.interface.yaml:1) |
| SV Package（packed req/rsp struct，View A） | [`rtl/aix_ready_valid_pkg.sv`](rtl/aix_ready_valid_pkg.sv:1) |
| SV Interface（source/sink/monitor modport，View B） | [`rtl/aix_ready_valid_if.sv`](rtl/aix_ready_valid_if.sv:1) |
| FuseSoC Core | [`aix_interface_ready_valid.core`](aix_interface_ready_valid.core:1) |

## 语义要点

- 传输成立条件：`valid && ready`；
- payload 在 stalled 期间必须保持稳定（`payload_stable_while_stalled: true`）；
- combinational ready-to-valid 路径禁止（`combinational_ready_to_valid: forbidden`）；
- 可选能力：`byte_keep`（keep 位）、`packet_boundary`（last）、`user_sideband`（user）；
- 本接口族不提供协议 SVA/Checker，由对应 VIP Core 依赖本 Core 后提供。

## 依赖

```text
aix:interface:common:1.0.0  →  aix:interface:ready_valid:1.0.0
```
