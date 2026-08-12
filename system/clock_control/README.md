# clock_control — 时钟控制接口（L1，P1 骨架）

时钟 enable/gate status/mux request/ack/safe switch 抽象。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/clock_control.interface.yaml`](contract/clock_control.interface.yaml:1) |
| FuseSoC Core | [`aix_interface_clock_control.core`](aix_interface_clock_control.core:1) |

## 状态

- 生命周期：`draft`；骨架阶段仅提供 Contract 与 Core；
- 待补充：SV package/interface、safe switch 语义、与 `clock` 接口族的关联。
