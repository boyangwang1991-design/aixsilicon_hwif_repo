# IFC-HAC_MGMT-001 — aix_hac_mgmt

- **Family**: `hac_mgmt`
- **SemVer**: `1.0.0`
- **Owner**: `hw-platform`
- **Lifecycle**: `draft`

## Roles

- `shell`
- `core`

## Parameters


## Channels / Signals

### `reset_ctrl` (handshake=req_ack)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `reset_req` | shell | core | 1 | True | - |
| `reset_ack` | core | shell | 1 | True | - |

### `drain_ctrl` (handshake=req_ack)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `drain_req` | shell | core | 1 | True | - |
| `drain_ack` | core | shell | 1 | True | - |

### `isolate_ctrl` (handshake=req_ack)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `isolate_req` | shell | core | 1 | False | isolation |
| `isolate_ack` | core | shell | 1 | False | isolation |

### `status` (handshake=none)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `quiescent` | core | shell | 1 | True | - |
| `idle` | core | shell | 1 | True | - |
| `clock_gate_ok` | core | shell | 1 | False | clock_gating |
| `fatal_state` | core | shell | 1 | True | - |

## Capabilities

- `isolation` (default=False)
- `clock_gating` (default=False)

## Semantics

- **source**: `AIXSILICON HAC organization 1.0, 2026-10-04`
- **handshake**: `valid && ready 同周期消费；valid置位不组合依赖ready；阻塞期间valid与全部载荷保持直到握手。`
- **optional_driver**: `可选字段启用时由from角色唯一驱动；关闭时由该发送方按default_tieoff驱动，接口视图不无条件绑死。`
- **width_policy**: `物理宽度参数至少1；关闭的逻辑字段在绑定层省略或常量驱动，不生成负索引向量。`
- **level_handshake**: `reset/drain/isolate为四相电平req/ack：请求者保持req到ack，之后撤req；响应者观察req撤回后撤ack，回到req=ack=0才开始下一轮。ack只在已观察到req后置1，不能自发确认；ack置位后保持直到观察req撤回。`
- **drain**: `drain_req停止新准入，保持已承诺valid/访问直到收敛；drain_ack仅在所有相关任务/配置/系统响应/stream/完成/必要event清空后置1，req保持期间不接新任务。`
- **reset**: `正常reset_req仅在drain_ack=1或受控隔离恢复证明无未来副作用后发出；reset_ack确认复位结束，清计算配置不清首错。reset不等于撤销AXI。`
- **isolation**: `isolate_ack只确认定义范围的隔离屏障已建立，不自动表示旧写已撤销或可回收buffer。失败恢复仍须平台证明。`
- **quiescent**: `整个执行域无待发completion/必要event和访存/流义务；与单任务CTRL safe terminal不同。idle仅无活动计算。`
- **clock_gate**: `关闭clock_gating时clock_gate_ok保守0；启用时仅允许在quiescent及binding唤醒条件满足时置1。`
- **recovery**: `超时进入恢复而非伪造ack；epoch仅隔离旧反馈，不阻止旧写；释放资源前证明排空，清故障不自动online。`
- **drain_configuration**: `drain保持期间禁止新commit/cmd。尚未发布的配置响应仍需消费；已成功提交但未启动的槽在drain中安全discard并回收身份，不生成cpl；已接收cmd继续执行或依binding取消并消费cpl。提交者持续接收cfg_rsp/cpl/必要event，不能先停接收再等drain_ack。`

## Views

- `packed_struct`: False
- `sv_interface`: True
- `flattened`: False
- `ipxact`: optional
- `notes`: 本版发布参数化SV interface/doc/IP-XACT；flat生成器目前为占位，不作为可用连接视图发布。可选信号保留物理线，由端点按binding驱动；旧固定宽度package不进入1.0 fileset。
