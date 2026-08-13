# HAC-EVENT — 事件接口

> 完成、错误、性能及中断事件，采用 `valid/ready + event payload`，中断由 Shell 根据事件策略生成。P0 及以上必选。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/hac_event.interface.yaml`](contract/hac_event.interface.yaml:1) |
| SV Package | [`rtl/aix_hac_event_pkg.sv`](rtl/aix_hac_event_pkg.sv:1) |
| SV Interface | [`rtl/aix_hac_event_if.sv`](rtl/aix_hac_event_if.sv:1) |
| FuseSoC Core | [`aix_interface_hac_event.core`](aix_interface_hac_event.core:1) |

## 事件字段

```text
event_type / severity / source / job_id / code / info
```

## 事件分类

| 类型 | 示例 |
|---|---|
| Completion | 任务完成、阶段完成 |
| Recoverable Error | 参数错误、可恢复 ECC、输入欠载 |
| Fatal Error | 不可恢复 ECC、状态机失控、内部一致性错误 |
| Performance | Counter 溢出、阈值触发 |
| Security | 非法地址、权限错误、完整性错误 |
| Debug | Trace 触发、断点、快照完成 |

## 中断策略

- Core 不直接产生面向 CPU 的中断协议，由 Shell 将事件映射到 IRQ/MSI/消息中断；
- 支持中断聚合、屏蔽、节流、W1C 状态；
- 错误事件在被消费前不得静默丢失；
- Fatal 事件应有独立粘滞状态，软复位不得默认清除诊断证据。
