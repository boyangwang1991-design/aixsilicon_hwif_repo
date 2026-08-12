# power_state — 电源状态接口（L1，P1 骨架）

power request/accept/state、wake event 抽象。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/power_state.interface.yaml`](contract/power_state.interface.yaml:1) |
| FuseSoC Core | [`aix_interface_power_state.core`](aix_interface_power_state.core:1) |

## 状态

- 生命周期：`draft`；骨架阶段仅提供 Contract 与 Core；
- 待补充：SV package/interface、power state 编码、与 `isolation`/`retention` 的关联；
- 电源域隔离方向与 clamp 值在 channel 的 `power` 属性中声明。
