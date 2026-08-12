# reset — 复位接口（L0）

描述复位域语义：async/sync、polarity、assert/deassert。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/reset.interface.yaml`](contract/reset.interface.yaml:1) |
| SV Package | [`rtl/aix_reset_pkg.sv`](rtl/aix_reset_pkg.sv:1) |
| SV Interface | [`rtl/aix_reset_if.sv`](rtl/aix_reset_if.sv:1) |
| FuseSoC Core | [`aix_interface_reset.core`](aix_interface_reset.core:1) |

## 语义要点（详见 [`docs/modeling-guide/README.md`](../../docs/modeling-guide/README.md:1)）

- 必须声明 polarity、assertion 同步/异步、deassertion 同步/异步、所属 clock；
- 必须声明 reset 期间输出要求、释放后最小稳定周期、能否打断未完成事务；
- 本接口只声明复位契约，不复位同步器实现（归 CBB/Techlib）。
