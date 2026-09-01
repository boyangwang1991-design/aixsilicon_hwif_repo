# clock — 时钟接口（L0）

描述主时钟、派生时钟、clock enable、频率属性。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/clock.interface.yaml`](contract/clock.interface.yaml:1) |
| SV Package | [`rtl/clock_pkg.sv`](rtl/clock_pkg.sv:1) |
| SV Interface | [`rtl/clock_if.sv`](rtl/clock_if.sv:1) |
| FuseSoC Core | [`interface_clock.core`](interface_clock.core:1) |

## 语义要点

- 角色：`controller` / `endpoint`；
- 每个时钟域必须声明 edge、可选的频率属性；
- clock enable（门控）语义作为独立能力描述；
- 本接口只声明时钟契约，不实现时钟门控/分频电路（归 CBB/Techlib）。
