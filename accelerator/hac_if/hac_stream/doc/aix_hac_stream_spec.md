# IFC-HAC_STRM-001 — aix_hac_stream

- **Family**: `hac_stream`
- **SemVer**: `1.0.0`
- **Owner**: `hw-platform`
- **Lifecycle**: `draft`

## Roles

- `producer`
- `consumer`

## Parameters

- `DATA_W` (type=uint, default=128)
- `ID_W` (type=uint, default=4)
- `USER_W` (type=uint, default=8)

## Channels / Signals

### `data` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `valid` | producer | consumer | 1 | True | - |
| `ready` | consumer | producer | 1 | True | - |
| `data` | producer | consumer | DATA_W | True | - |
| `keep` | producer | consumer | DATA_W/8 | False | keep |
| `last` | producer | consumer | 1 | False | last |
| `id` | producer | consumer | ID_W | False | id |
| `user` | producer | consumer | USER_W | False | user |

## Capabilities

- `keep` (default=True)
- `last` (default=True)
- `id` (default=False)
- `user` (default=False)

## Semantics

- **source**: `AIXSILICON HAC organization 1.0, 2026-10-04`
- **handshake**: `valid && ready 同周期消费；valid置位不组合依赖ready；阻塞期间valid与全部载荷保持直到握手。`
- **optional_driver**: `可选字段启用时由from角色唯一驱动；关闭时由该发送方按default_tieoff驱动，接口视图不无条件绑死。`
- **width_policy**: `物理宽度参数至少1；关闭的逻辑字段在绑定层省略或常量驱动，不生成负索引向量。`
- **axis_subset**: `data/keep/last/id/user分别映射TDATA/TKEEP/TLAST/TID/TUSER。基础无TSTRB位置字节、TDEST隐式路由或beat级任务交织。`
- **keep**: `每位对应一个有效Byte，关闭时按全有效处理。基础有效字节从低lane连续；尾拍保留完整元素，不允许零keep握手。`
- **boundary**: `每条边binding必须唯一指定frame/tile/packet及任务边界数量；last不能同时表示不同粒度。关闭last时binding给固定长度计数。`
- **task**: `首版每端口仅一个活动job，由Shell上下文关联；id可标识流，但不授权任务交织。`
- **format**: `binding必须定义dtype/符号/精度/舍入/layout/shape/字节序/lane顺序/尾拍及多输入配对。`
- **adaptation**: `仅格式相同可直连；位宽转换保持元素/边界，转置/量化/广播为显式经过验证模块。`
- **lifecycle**: `sink与输出容量先准备再启动source；route在任务中冻结。取消不单方撤回valid，受控排空/隔离后重同步。`
- **unstallable**: `不可暂停核须预留整个不可暂停区间容量或具有速率保证的binding；有限FIFO不能承受无限反压。`

## Views

- `packed_struct`: False
- `sv_interface`: True
- `flattened`: False
- `ipxact`: optional
- `notes`: 本版发布参数化SV interface/doc/IP-XACT；flat生成器目前为占位，不作为可用连接视图发布。可选信号保留物理线，由端点按binding驱动；旧固定宽度package不进入1.0 fileset。
