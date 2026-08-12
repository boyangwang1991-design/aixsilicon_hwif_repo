# reset_control — 复位控制接口（L1，P1 骨架）

复位 request/cause/status、domain reset handshake 抽象。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/reset_control.interface.yaml`](contract/reset_control.interface.yaml:1) |
| FuseSoC Core | [`aix_interface_reset_control.core`](aix_interface_reset_control.core:1) |

## 状态

- 生命周期：`draft`；骨架阶段仅提供 Contract 与 Core；
- 待补充：SV package/interface、cause/status 编码、多 reset 域关系。
