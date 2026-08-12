# event — 事件接口（L0）

描述 pulse、level、toggle 三类事件。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/event.interface.yaml`](contract/event.interface.yaml:1) |
| SV Package | [`rtl/aix_event_pkg.sv`](rtl/aix_event_pkg.sv:1) |
| SV Interface | [`rtl/aix_event_if.sv`](rtl/aix_event_if.sv:1) |
| FuseSoC Core | [`aix_interface_event.core`](aix_interface_event.core:1) |

## 语义要点

- 事件类型：`pulse`（单周期脉冲）/ `level`（电平保持）/ `toggle`（边沿翻转）；
- 角色：`source` / `receiver`；
- 用于内部事件通知，与 interrupt（带极性/向量/应答语义）区分。
