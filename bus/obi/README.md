# obi — RISC-V OBI 总线接口（L3，P1 骨架）

RISC-V CPU/加速器 OBI 接口，按项目需要建设（OpenHW OBI 规范）。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/obi.interface.yaml`](contract/obi.interface.yaml:1) |
| FuseSoC Core | [`aix_interface_obi.core`](aix_interface_obi.core:1) |

## 状态

- 生命周期：`draft`；骨架阶段仅提供 Contract 与 Core；
- 待补充：SV package/interface、optional signal 使用方式、Profile。
- 参考：OpenHW OBI（`https://docs.openhwgroup.org/projects/cv32e40p-user-manual/`）。
