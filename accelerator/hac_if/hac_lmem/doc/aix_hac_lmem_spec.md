# IFC-HAC_LMEM-001 — aix_hac_lmem

- **Family**: `hac_lmem`
- **SemVer**: `1.0.0`
- **Owner**: `hw-platform`
- **Lifecycle**: `draft`

## Roles

- `core`
- `lmem`

## Parameters

- `DATA_W` (type=uint, default=64)
- `ADDR_W` (type=uint, default=16)
- `BANK_W` (type=uint, default=1)
- `TAG_W` (type=uint, default=4)
- `MAX_OUTSTANDING` (type=uint, default=1)
- `READ_LATENCY` (type=uint, default=1)

## Channels / Signals

### `req` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `req_valid` | core | lmem | 1 | True | - |
| `req_ready` | lmem | core | 1 | True | - |
| `write` | core | lmem | 1 | True | - |
| `bank` | core | lmem | BANK_W | False | multi_bank |
| `addr` | core | lmem | ADDR_W | True | - |
| `wdata` | core | lmem | DATA_W | True | - |
| `wstrb` | core | lmem | DATA_W/8 | True | - |
| `req_tag` | core | lmem | TAG_W | False | decoupled |

### `rsp` (handshake=ready_valid)

| Signal | From | To | Width | Required | Capability |
|---|---|---|---|---|---|
| `rsp_valid` | lmem | core | 1 | True | - |
| `rsp_ready` | core | lmem | 1 | True | - |
| `rdata` | lmem | core | DATA_W | True | - |
| `rsp_status` | lmem | core | 4 | True | - |
| `rsp_tag` | lmem | core | TAG_W | False | decoupled |
| `ecc_corrected` | lmem | core | 1 | False | ecc |
| `ecc_uncorrectable` | lmem | core | 1 | False | ecc |

## Capabilities

- `multi_bank` (default=False)
- `decoupled` (default=False)
- `ecc` (default=False)

## Semantics

- **source**: `AIXSILICON HAC organization 1.0, 2026-10-04`
- **handshake**: `valid && ready 同周期消费；valid置位不组合依赖ready；阻塞期间valid与全部载荷保持直到握手。`
- **optional_driver**: `可选字段启用时由from角色唯一驱动；关闭时由该发送方按default_tieoff驱动，接口视图不无条件绑死。`
- **width_policy**: `物理宽度参数至少1；关闭的逻辑字段在绑定层省略或常量驱动，不生成负索引向量。`
- **address**: `addr为bank内Byte偏移；请求按DATA_W/8对齐，write=1写/0读，wstrb为有效Byte。读wdata/wstrb为0。范围与bank合法性由binding明确。`
- **completion**: `读和写每次req握手都有一次rsp；写rsp表示本地副作用及错误已确定，rdata在写rsp无语义为0。status编码同MEM，0成功。`
- **fixed**: `decoupled=false，MAX_OUTSTANDING=1；请求后READ_LATENCY周期产生rsp_valid，背压时响应保持。接收请求前预留响应存储，不把无ready宏响应直接接过来。`
- **decoupled**: `decoupled=true，可变延迟，响应按请求顺序；每个req_tag在rsp消费前唯一。MAX_OUTSTANDING限制未消费响应数。`
- **ecc**: `ecc_corrected为已纠正提示；uncorrectable必须伴随非0rsp_status且数据不可消费。两者不得同时置1。`
- **macro**: `Core不绑定foundry宏；宏延迟/ECC/retention由Memory Wrapper映射，未完成访问计入排空。`

## Views

- `packed_struct`: False
- `sv_interface`: True
- `flattened`: False
- `ipxact`: optional
- `notes`: 本版发布参数化SV interface/doc/IP-XACT；flat生成器目前为占位，不作为可用连接视图发布。可选信号保留物理线，由端点按binding驱动；旧固定宽度package不进入1.0 fileset。
