# safety_event — 安全事件接口（L6，P0）

fault ID、severity、domain、timestamp、ack。功能安全核心事件通道。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/safety_event.interface.yaml`](contract/safety_event.interface.yaml:1) |
| SV Package | [`rtl/aix_safety_event_pkg.sv`](rtl/aix_safety_event_pkg.sv:1) |
| SV Interface | [`rtl/aix_safety_event_if.sv`](rtl/aix_safety_event_if.sv:1) |
| FuseSoC Core | [`aix_interface_safety_event.core`](aix_interface_safety_event.core:1) |

## 语义要点

- 角色：`source` / `receiver`；
- 载荷：fault ID、severity（recoverable/fatal）、domain、timestamp；
- ack 可选（valid/ack 握手）；
- Profile：`safety_event_v1`（对应 plan 第 12.2 节）。
