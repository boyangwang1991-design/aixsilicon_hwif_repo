# fifo_push_pop — FIFO 推/弹接口（L2）

push/pop、full/empty、level、overflow/underflow。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/fifo_push_pop.interface.yaml`](contract/fifo_push_pop.interface.yaml:1) |
| SV Package | [`rtl/aix_fifo_push_pop_pkg.sv`](rtl/aix_fifo_push_pop_pkg.sv:1) |
| SV Interface | [`rtl/aix_fifo_push_pop_if.sv`](rtl/aix_fifo_push_pop_if.sv:1) |
| FuseSoC Core | [`aix_interface_fifo_push_pop.core`](aix_interface_fifo_push_pop.core:1) |

## 语义要点

- 角色：`producer`（push）/ `consumer`（pop）；
- 状态信号：`full`、`empty`、`level`；
- 溢出/下溢语义必须显式声明（饱和丢弃 / 报错 / 阻塞）；
- FIFO 实现（同步/异步、指针、CDC）归 CBB/Techlib。
