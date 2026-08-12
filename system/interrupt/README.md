# interrupt — 中断接口（L1）

SoC 公共中断控制接口，覆盖 level/pulse、polarity、vector、source/sink、可选 ack。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/interrupt.interface.yaml`](contract/interrupt.interface.yaml:1) |
| SV Package | [`rtl/aix_interrupt_pkg.sv`](rtl/aix_interrupt_pkg.sv:1) |
| SV Interface | [`rtl/aix_interrupt_if.sv`](rtl/aix_interrupt_if.sv:1) |
| FuseSoC Core | [`aix_interface_interrupt.core`](aix_interface_interrupt.core:1) |

## 语义要点

- 角色：`source` / `receiver`；
- 能力：`level`、`pulse`、`vector`、`acknowledged`；
- 优先级：`interrupt_level_v1`、`interrupt_pulse_v1`（见 [`profiles/organization/`](../../profiles/organization/README.md:1)）；
- 中断聚合、优先级仲裁、pulse→level 转换属于 CBB，不在此定义实现。

## 依赖

```text
aix:interface:common → aix:interface:interrupt
```
