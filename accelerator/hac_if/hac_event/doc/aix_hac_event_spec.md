# IFC-HAC_EVT-001 — aix_hac_event

- **Family**: `hac_event`
- **SemVer**: `1.0.0`
- **Owner**: `hw-platform`
- **Lifecycle**: `draft`

## Roles

- `core`
- `shell`

## Parameters

- `EVENT_TYPE_W` (type=uint, default=3)
- `SEVERITY_W` (type=uint, default=2)
- `SOURCE_W` (type=uint, default=8)
- `JOB_ID_W` (type=uint, default=8)
- `CODE_W` (type=uint, default=16)
- `INFO_W` (type=uint, default=32)

## Channels / Signals

### `event` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `event_valid` | core | shell | 1 | True | - |
| `event_ready` | shell | core | 1 | True | - |
| `event_type` | core | shell | EVENT_TYPE_W | True | - |
| `severity` | core | shell | SEVERITY_W | True | - |
| `source` | core | shell | SOURCE_W | True | - |
| `job_id` | core | shell | JOB_ID_W | False | job_id |
| `code` | core | shell | CODE_W | True | - |
| `info` | core | shell | INFO_W | False | info |

## Capabilities

- `job_id` (default=True)
- `info` (default=True)

## Semantics

- **source**: `AIXSILICON HAC organization 1.0, 2026-10-04`
- **handshake**: `valid && ready 同周期消费；valid置位不组合依赖ready；阻塞期间valid与全部载荷保持直到握手。`
- **optional_driver**: `可选字段启用时由from角色唯一驱动；关闭时由该发送方按default_tieoff驱动，接口视图不无条件绑死。`
- **width_policy**: `物理宽度参数至少1；关闭的逻辑字段在绑定层省略或常量驱动，不生成负索引向量。`
- **types**: `0终态通知镜像，1可恢复错误，2fatal，3性能，4安全，5debug，6非终态进展，7保留；severity 0info/1warning/2fatal/3保留。`
- **completion_mirror**: `type0仅通知已由CTRL确认的终态，不再次释放资源/唤醒依赖；进展不使用type0。`
- **buffering**: `必要错误独立预留容量，不因完成通道反压形成循环等待。可丢性能/debug只允许握手前按明确策略丢弃并计数；valid置位后不可撤回。`
- **fatal**: `fatal有独立粘滞证据，局部软复位不能清除；特权显式清理不等于解除隔离。`
- **irq**: `IRQ/MSI由Shell或共享平台生成，Core只发送语义事件。`

## Views

- `packed_struct`: False
- `sv_interface`: True
- `flattened`: False
- `ipxact`: optional
- `notes`: 本版发布参数化SV interface/doc/IP-XACT；flat生成器目前为占位，不作为可用连接视图发布。可选信号保留物理线，由端点按binding驱动；旧固定宽度package不进入1.0 fileset。
