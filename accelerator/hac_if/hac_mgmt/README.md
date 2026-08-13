# HAC-MGMT — 管理接口

> 复位、功耗、隔离、调试和生命周期管理。推荐（P4 必选增强能力）。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/hac_mgmt.interface.yaml`](contract/hac_mgmt.interface.yaml:1) |
| SV Package | [`rtl/aix_hac_mgmt_pkg.sv`](rtl/aix_hac_mgmt_pkg.sv:1) |
| SV Interface | [`rtl/aix_hac_mgmt_if.sv`](rtl/aix_hac_mgmt_if.sv:1) |
| FuseSoC Core | [`aix_interface_hac_mgmt.core`](aix_interface_hac_mgmt.core:1) |

## 复位与生命周期

- `reset_req/reset_ack`：受控软复位；
- `drain_req/drain_ack`：停止接收新任务并排空；
- `quiescent`：可安全关钟/断电；
- `isolate_req/isolate_ack`：隔离握手；
- `fatal_state`：需要系统级恢复。

软复位流程：`Power/Reset Manager` → `drain_req` → HAC Shell 停止接收任务 → HAC Core 返回 `quiescent` → `drain_ack` → `reset_req` → `reset_ack`。

## 低功耗

至少支持：

- 空闲指示；
- 可关钟指示；
- Retention 能力声明；
- 进入低功耗前事务排空；
- 唤醒源声明；
- 断电域跨越时的隔离要求。

## 调试与性能

统一预留：

- 周期数、忙周期、停顿周期；
- 读写 Byte 数；
- 平均/峰值 Outstanding；
- Stream 背压周期；
- Cache/SRAM 等待周期；
- 任务计数和失败计数；
- 可选 Trace Event 输出。
