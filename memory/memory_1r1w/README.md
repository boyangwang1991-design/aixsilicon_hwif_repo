# memory_1r1w — 独立读写端口内存接口（L2）

独立读端口与写端口、collision policy。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/memory_1r1w.interface.yaml`](contract/memory_1r1w.interface.yaml:1) |
| SV Package | [`rtl/aix_memory_1r1w_pkg.sv`](rtl/aix_memory_1r1w_pkg.sv:1) |
| SV Interface | [`rtl/aix_memory_1r1w_if.sv`](rtl/aix_memory_1r1w_if.sv:1) |
| FuseSoC Core | [`aix_interface_memory_1r1w.core`](aix_interface_memory_1r1w.core:1) |

## 语义要点

- 角色：`requester` / `memory`；
- 独立读写端口：读端口与写端口不共享请求；
- collision policy：同地址读写同一拍的行为必须显式声明（read-during-write）。
