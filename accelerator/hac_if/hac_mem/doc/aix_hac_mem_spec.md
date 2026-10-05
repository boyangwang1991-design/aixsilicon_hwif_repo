# IFC-HAC_MEM-001 — aix_hac_mem

- **Family**: `hac_mem`
- **SemVer**: `1.0.0`
- **Owner**: `hw-platform`
- **Lifecycle**: `draft`

## Roles

- `core`
- `adapter`

## Parameters

- `ADDR_W` (type=uint, default=64)
- `DATA_W` (type=uint, default=128)
- `LEN_W` (type=uint, default=32)
- `TAG_W` (type=uint, default=6)
- `JOB_ID_W` (type=uint, default=8)
- `ATTR_W` (type=uint, default=8)
- `MAX_OUTSTANDING` (type=uint, default=1)

## Channels / Signals

### `read_req` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `req_valid` | core | adapter | 1 | True | - |
| `req_ready` | adapter | core | 1 | True | - |
| `req_addr` | core | adapter | ADDR_W | True | - |
| `req_len_bytes` | core | adapter | LEN_W | True | - |
| `req_tag` | core | adapter | TAG_W | True | - |
| `req_job_id` | core | adapter | JOB_ID_W | False | job_id |
| `req_attr` | core | adapter | ATTR_W | False | attr |

### `read_rsp` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `rsp_valid` | adapter | core | 1 | True | - |
| `rsp_ready` | core | adapter | 1 | True | - |
| `rsp_data` | adapter | core | DATA_W | True | - |
| `rsp_tag` | adapter | core | TAG_W | True | - |
| `rsp_last` | adapter | core | 1 | True | - |
| `rsp_status` | adapter | core | 4 | True | - |

### `write_req` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `wreq_valid` | core | adapter | 1 | True | - |
| `wreq_ready` | adapter | core | 1 | True | - |
| `wreq_addr` | core | adapter | ADDR_W | True | - |
| `wreq_len_bytes` | core | adapter | LEN_W | True | - |
| `wreq_tag` | core | adapter | TAG_W | True | - |
| `wreq_job_id` | core | adapter | JOB_ID_W | False | job_id |
| `wreq_attr` | core | adapter | ATTR_W | False | attr |

### `write_data` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `wdata_valid` | core | adapter | 1 | True | - |
| `wdata_ready` | adapter | core | 1 | True | - |
| `wdata` | core | adapter | DATA_W | True | - |
| `wstrb` | core | adapter | DATA_W/8 | True | - |
| `wdata_tag` | core | adapter | TAG_W | True | - |
| `wdata_last` | core | adapter | 1 | True | - |

### `write_rsp` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `wrsp_valid` | adapter | core | 1 | True | - |
| `wrsp_ready` | core | adapter | 1 | True | - |
| `wrsp_tag` | adapter | core | TAG_W | True | - |
| `wrsp_status` | adapter | core | 4 | True | - |

## Capabilities

- `job_id` (default=False)
- `attr` (default=False)
- `out_of_order` (default=False)
- `unaligned_access` (default=False)

## Semantics

- **source**: `AIXSILICON HAC organization 1.0, 2026-10-04`
- **handshake**: `valid && ready 同周期消费；valid置位不组合依赖ready；阻塞期间valid与全部载荷保持直到握手。`
- **optional_driver**: `可选字段启用时由from角色唯一驱动；关闭时由该发送方按default_tieoff驱动，接口视图不无条件绑死。`
- **width_policy**: `物理宽度参数至少1；关闭的逻辑字段在绑定层省略或常量驱动，不生成负索引向量。`
- **address**: `addr为Byte地址；len_bytes>0，完整请求有效字节数。基础地址按DATA_W/8对齐，尾部可不满beat。`
- **writes**: `每请求wreq只握手一次，数据不早于该握手；首版按wreq接收顺序连续发送，不交织不同请求。ceil(len_bytes/(DATA_W/8))个beat，last仅末拍。`
- **strobe**: `除尾拍外全有效，尾拍低字节连续有效且总数等于len_bytes；稀疏掩码不在基础范围。`
- **tag**: `读写tag空间独立；各自最终rsp(last)/wrsp消费前不复用。MAX_OUTSTANDING分别限制各方向。`
- **ordering**: `out_of_order=false时各方向请求顺序响应，true时可跨tag乱序但每tag内保序；写数据仍不交织。`
- **response**: `status=0有效数据/成功；1 decode、2 slave、3 parity、4 security、5 timeout、6 protocol、7 cancelled，8..15保留。读错误末拍last=1且data无效，终结返回有效前缀。`
- **partial_failure**: `写错误不承诺无副作用，已写范围未知，输出buffer失效，不自动重试。读提前错误后系统迟到响应由Adapter继续收敛。`
- **system_visibility**: `wrsp成功确认该请求全部系统写响应收敛，不替代跨master/cache可见性合同。`
- **timeout**: `逻辑错误响应不能授权系统ID提前复用；Adapter保留系统记录直至平台排空。核侧tag可在响应后回收但端点不发布safe terminal或quiescent，直到旧请求副作用收敛。`
- **adapter**: `AXI burst长度、4KiB切分、ID映射、属性及保护由Adapter承担，core不处理RRESP/BRESP。`
- **attributes**: `attr只为受约束hint；权限由可信Shell施加，不可由Core提升。`
- **unsupported**: `基础仅Read/Write，无prefetch/atomic编码或能力；非对齐关闭时拒绝，不截断地址。`

## Views

- `packed_struct`: False
- `sv_interface`: True
- `flattened`: False
- `ipxact`: optional
- `notes`: 本版发布参数化SV interface/doc/IP-XACT；flat生成器目前为占位，不作为可用连接视图发布。可选信号保留物理线，由端点按binding驱动；旧固定宽度package不进入1.0 fileset。
