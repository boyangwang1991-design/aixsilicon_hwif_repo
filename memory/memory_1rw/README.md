# memory_1rw — 单端口读写内存接口（L2）

单端口读写、mask、latency profile。SRAM Macro 的物理 pin/时序归 `hw-techlib`，本接口提供逻辑抽象。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/memory_1rw.interface.yaml`](contract/memory_1rw.interface.yaml:1) |
| SV Package | [`rtl/aix_memory_1rw_pkg.sv`](rtl/aix_memory_1rw_pkg.sv:1) |
| SV Interface | [`rtl/aix_memory_1rw_if.sv`](rtl/aix_memory_1rw_if.sv:1) |
| FuseSoC Core | [`aix_interface_memory_1rw.core`](aix_interface_memory_1rw.core:1) |

## 语义要点

- 角色：`requester` / `memory`；
- 单端口（读写共用端口，通过 `we` 区分）；
- `be` 写掩码；latency profile 由参数声明；
- Techlib 负责映射到具体 SRAM Macro。
