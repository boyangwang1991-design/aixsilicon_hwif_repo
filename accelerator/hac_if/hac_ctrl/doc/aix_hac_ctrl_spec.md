# IFC-HAC_CTRL-001 — aix_hac_ctrl

- **Family**: `hac_ctrl`
- **SemVer**: `1.0.0`
- **Owner**: `hw-platform`
- **Lifecycle**: `draft`

## Roles

- `shell`
- `core`

## Parameters

- `JOB_ID_W` (type=uint, default=8)
- `OPCODE_W` (type=uint, default=8)
- `ADDR_W` (type=uint, default=64)
- `FLAGS_W` (type=uint, default=16)
- `STATUS_W` (type=uint, default=16)
- `CFG_SLOT_W` (type=uint, default=1)
- `PARAM_VERSION_W` (type=uint, default=16)
- `PARAM_LEN_W` (type=uint, default=32)
- `MAX_INFLIGHT` (type=uint, default=1)

## Channels / Signals

### `cfg_commit` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `cfg_commit_valid` | shell | core | 1 | False | config_commit |
| `cfg_commit_ready` | core | shell | 1 | False | config_commit |
| `cfg_commit_job_id` | shell | core | JOB_ID_W | False | config_commit |
| `cfg_commit_slot` | shell | core | CFG_SLOT_W | False | config_commit |

### `cfg_response` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `cfg_rsp_valid` | core | shell | 1 | False | config_commit |
| `cfg_rsp_ready` | shell | core | 1 | False | config_commit |
| `cfg_rsp_job_id` | core | shell | JOB_ID_W | False | config_commit |
| `cfg_rsp_slot` | core | shell | CFG_SLOT_W | False | config_commit |
| `cfg_rsp_status` | core | shell | STATUS_W | False | config_commit |

### `cmd` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `cmd_valid` | shell | core | 1 | True | - |
| `cmd_ready` | core | shell | 1 | True | - |
| `cmd_job_id` | shell | core | JOB_ID_W | True | - |
| `cmd_opcode` | shell | core | OPCODE_W | True | - |
| `cmd_cfg_slot` | shell | core | CFG_SLOT_W | False | config_commit |
| `cmd_desc_addr` | shell | core | ADDR_W | False | descriptor |
| `cmd_param_version` | shell | core | PARAM_VERSION_W | False | descriptor |
| `cmd_param_bytes` | shell | core | PARAM_LEN_W | False | descriptor |
| `cmd_flags` | shell | core | FLAGS_W | False | cmd_flags |

### `cpl` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `cpl_valid` | core | shell | 1 | True | - |
| `cpl_ready` | shell | core | 1 | True | - |
| `cpl_job_id` | core | shell | JOB_ID_W | True | - |
| `cpl_status` | core | shell | STATUS_W | True | - |

### `cancel` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `cancel_valid` | shell | core | 1 | False | cancel |
| `cancel_ready` | core | shell | 1 | False | cancel |
| `cancel_job_id` | shell | core | JOB_ID_W | False | cancel |

### `status` (handshake=none)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `busy` | core | shell | 1 | True | - |
| `idle` | core | shell | 1 | True | - |
| `quiescent` | core | shell | 1 | True | - |

## Capabilities

- `config_commit` (default=True)
- `descriptor` (default=False)
- `cancel` (default=False)
- `cmd_flags` (default=False)

## Semantics

- **source**: `AIXSILICON HAC organization 1.0, 2026-10-04`
- **handshake**: `valid && ready 同周期消费；valid置位不组合依赖ready；阻塞期间valid与全部载荷保持直到握手。`
- **optional_driver**: `可选字段启用时由from角色唯一驱动；关闭时由该发送方按default_tieoff驱动，接口视图不无条件绑死。`
- **width_policy**: `物理宽度参数至少1；关闭的逻辑字段在绑定层省略或常量驱动，不生成负索引向量。`
- **endpoint**: `shell为提交者；core为受管理的执行端点（可以是Wrapper/Engine Shell），并不要求原始算法核理解所有字段。`
- **configuration_load**: `算法专用数据由受控寄存器/原生参数binding装载；完整加载及校验后才能发送cfg_commit_valid。此接口不规定通用参数数据总线。`
- **commit**: `一个cfg_commit握手对应一次cfg_rsp；首版仅一个commit在途。响应携带相同job/slot，0成功、非0失败。握手不等于验证成功。`
- **slot_ownership**: `成功cfg_rsp消费后slot进入已提交状态；cmd匹配job/slot并握手后成为活动配置。执行及其义务收敛前不可覆盖。配置槽数与MAX_INFLIGHT独立。`
- **commit_cancel**: `未启动的已提交配置通过受控MGMT drain/reset或算法binding discard回收；不产生无cmd的cpl。`
- **command**: `config_commit模式中提交者只对成功配置发cmd。接收者若握手了非法opcode/slot，仍返回一次错误cpl。descriptor模式由端点取参数；empty模式不取地址。config_commit与descriptor不能同时启用。`
- **flags**: `首版所有cmd_flags保留为0；非零拒绝，后续语义版本化。`
- **completion**: `每个cmd握手对应一次safe terminal cpl（设备级复位破坏通道时由恢复结算）。0x0000为成功，所有非零为错误/取消。EVENT不能再次结算。`
- **safe_terminal**: `成功前输出达到binding可见域；失败前隔离/排空确认该任务无未来副作用。compute_done不等于cpl。`
- **job_identity**: `job_id在cmd接收直到cpl消费之间唯一；预提交配置亦保留对应身份，MAX_INFLIGHT限制已接收未消费完成数。`
- **ordering**: `基础完成按cmd接收顺序；MAX_INFLIGHT=1为首版。跨job乱序需要单独版本/profile，不由该字段自动授权。`
- **cancel**: `cancel握手只确认取消请求已记录，仍经cpl返回一次终态。自然完成先确定则保留；未知/已完成job的cancel消费后无副作用，不生成第二cpl。无abort时由外层等待或受控恢复。`
- **status**: `idle仅无活动计算；quiescent还要求配置交付、访存、流、completion及必要event均无待处理义务。`
- **admission**: `在cmd_ready前预留执行/配置及完成容量；完成反压不得丢终态或提前复用job。`
- **status_codes**: `16位状态：0x0000 OK；0x0001非法opcode、0x0002配置、0x0003长度、0x0004资源、0x0005访存、0x0006超时、0x0007取消、0x0008内部故障、0x0009格式、0x000A权限；0x0100..0x7FFF算法错误由binding定义；其它保留。所有非0一律非成功。cfg_rsp采用同编码，配置失败回收job/slot，不发无cmd的cpl。`

## Views

- `packed_struct`: False
- `sv_interface`: True
- `flattened`: False
- `ipxact`: optional
- `notes`: 本版发布参数化SV interface/doc/IP-XACT；flat生成器目前为占位，不作为可用连接视图发布。可选信号保留物理线，由端点按binding驱动；旧固定宽度package不进入1.0 fileset。
