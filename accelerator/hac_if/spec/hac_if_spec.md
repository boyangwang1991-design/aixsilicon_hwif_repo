# HAC-IF 1.0 draft — 集成契约

版本：2026-10-04；SemVer `1.0.0`；lifecycle `draft`。语义来源为最终 HAC 组织方案，字段、方向、位宽、能力、时序和错误规则以六份 Contract YAML 为准。本文提供组合与系统绑定规则，不维护第二份信号表。

## 1. 边界与组合

CTRL 的 shell 为提交端，core 为受管理执行端点，可由 Wrapper / Engine Shell 承担。算法核可以保留原生配置、AXI、stream 或 SRAM 端口；不能要求存量核直接理解平台全部协议。平台边界的 safe terminal 覆盖供数、计算、输出和系统可见性，Wrapper 不能把原核 done 直接转成 cpl。

| 逻辑组合 | 必选家族 | 冻结 profile | 应用限制 |
|---|---|---|---|
| P0 Control | CTRL + EVENT + MGMT | [P0](../contract/hac_p0.profile.yaml)约束CTRL | config_commit，单在途任务 |
| P1 Stream | P0 + STREAM | P0 + [P1](../contract/hac_p1.profile.yaml) | keep/last，单端口一个活动job |
| P2 Memory | P0 + MEM | P0 + [P2](../contract/hac_p2.profile.yaml) | 对齐读写，每方向最多4在途，顺序响应 |
| P3 Hybrid | P0 + STREAM + MEM | P0 + P1 + P2组合 | 首版无独立P3 YAML，不承诺组合已验证 |

MGMT是基础执行管理，隔离、门控、取消和ECC是独立能力。LMEM按核需求附加；descriptor参数模式需要独立 binding/profile，经验证后启用，不是P0默认。组合配置明确每个family的参数和capability，不能用一个profile YAML引用另一个family不存在的参数。

## 2. 公共握手、时钟与宽度

所有通道同域上升沿采样；每实例单clock/reset，跨域由单独经验证adapter处理。`rst_n`异步断言、同步释放。复位期间发送方valid/req/ack为0；平台记录被复位任务的恢复结算，不要求被硬复位的通道继续返回cpl。

ready/valid只有同周期两者为1才消费；发送端不等待ready才拉valid，一旦valid置位，在反压时保持valid及载荷。接收端先预留容量才ready。每条物理线由Contract的from角色唯一驱动，关闭可选能力由同一端按tieoff驱动，interface自身不绑定常量。可选物理位宽至少1，禁止用0制造`[-1:0]`。默认及范围见各族生成规格；参数满足范围并不等于某实现支持全部取值。

`MAX_INFLIGHT/MAX_OUTSTANDING`是行为约束，不由interface声明实现队列。SV modport规定载荷方向；时钟/复位使用interface端口，由端点模块明确接入。

## 3. 配置到终态

1. Shell经算法专用配置binding装载非活动槽，校验版本、长度、权限和完整性。
2. Shell握手`cfg_commit(job,slot)`；端点返回同身份的`cfg_rsp`。commit接收不等于配置成功；首版一个commit在途。
3. 消费成功cfg_rsp后才能握手匹配的cmd；失败释放配置身份，无cmd则无cpl。成功槽在任务义务收敛前禁止覆盖。
4. cmd接收前预留执行及终态存储；即使接收的是非法opcode/slot，仍返回一次错误cpl。
5. compute_done只表示计算完成，output_done只表示输出通道结束。只有输出达到约定可见域、失败路径排空/隔离且没有未来副作用后才能发布safe terminal cpl。
6. cpl反压时保留身份和载荷；仅消费后job身份及完成槽可复用。EVENT完成镜像不再次结算。

CTRL所有非零状态均非成功，精确编码见[CTRL规格](../hac_ctrl/doc/aix_hac_ctrl_spec.md)。取消握手只确认请求记录；自然完成先确定则保留，否则以一次取消cpl结算；未知或已完成job不生成第二完成。超时后未证明无未来副作用，不能为了返回错误而发布safe terminal。

`idle`只表示没有活动计算；`quiescent`还要求所有配置、访存、流、完成及必要事件清空。CTRL/MGMT的quiescent若覆盖同一个执行域，必须一致。

## 4. 数据与存储

STREAM为AXIS兼容子集：`valid→TVALID`、`ready→TREADY`、`data→TDATA`、`keep→TKEEP`、`last→TLAST`、`id→TID`、`user→TUSER`。时钟/复位对应ACLK/ARESETn，静态映射见 [AXIS Binding](../hac_stream/contract/hac_stream_axis.binding.yaml)。基础无TSTRB/TDEST、稀疏位置字节或beat级job交织；AXIS原核超出此范围需显式转换，不能声明无条件兼容。

每条边绑定必须定义dtype/精度/符号/舍入、layout/shape、字节序/lane顺序、last粒度及数量、tail和多输入配对。低lane连续有效，不能传零keep或半个元素。关闭last时须明确固定长度；任务中route冻结。先准备sink及输出容量再启动source。不可暂停核需覆盖整个不可暂停区间的容量或服务保证。

MEM提供读请求/读响应/写请求/写数据/写响应五通道；地址和长度单位为Byte，长度必须正。写数据在写请求接收之后开始，无跨请求交织，拍数和尾部strobe由长度唯一确定。读写tag空间独立，各方向最终响应消费前禁止复用；基础按请求顺序响应。读提前错误终止逻辑返回后，Adapter仍须收敛迟到系统响应。写失败可能已有部分副作用，输出失效且不自动重试。AXI burst/4KiB切分/ID映射由Adapter负责。

LMEM是受控请求/响应口，不直接等同SRAM macro：写也有响应。fixed模式一个在途，READ_LATENCY指首次rsp_valid出现的周期数，反压后保持；decoupled模式允许可变延迟但顺序响应，req_tag/rsp_tag对应。接收前预留响应容量。bank、ECC、容量、端口冲突及映射由具体存储binding定义。

## 5. 系统绑定必须给出的信息

| Binding | 必须明确 | 所有者与实现边界 |
|---|---|---|
| 算法配置 | opcode、参数版本/长度、寄存器或原生数据装载口、槽容量、提交校验、discard、状态编码 | IP Wrapper；不是新增通用参数数据总线 |
| uDMA | HAC job ↔ native transfer/channel ↔ port有界映射、准入容量、字节/尾拍、完成与错误、排空证据 | CBB service adapter；复用现有uDMA，不能仅接线重命名 |
| HTS/软件后端 | task_tag/epoch ↔ job有界映射，dispatch接受点，完成存储，唯一结算，资源释放条件 | scheduler frontend；HTS未来后端不复制参数ABI |
| Legacy AXI核 | 原生AXI范围/权限、独立地址窗口、控制done至safe terminal的提升、复位恢复 | Shell监控全部原生访问，不伪称已转换为HAC-MEM |
| MEM ↔ 系统AXI | burst切分、ID池、权限、异常迟到响应、实际写可见域 | memory adapter；不能在逻辑tag回收时提前复用系统ID |
| LMEM ↔ SRAM | 容量、Byte映射、bank/端口、时序、ECC、冲突、读写一致性 | local-memory adapter |
| STREAM边 | 数值格式、边界、宽度变换、容量和暂停条件 | graph binding / pipeline controller |

这些是binding准入要求。本版未获得具体核的配置布局、uDMA产品配置或HTS实现，未伪造可执行信号绑定。具体Binding YAML使用仓库`schema/binding.schema.yaml`，状态机/可见域等该schema不能表达的内容由owner文档引用并验证。

## 6. 排空、复位及恢复

drain/reset/isolate采用四相req/ack：请求者保持req至ack，撤req后响应者撤ack，返回零状态再进行下一轮。ack只在已观察到req后置1，并保持至观察req撤回。drain停止新commit/cmd，但不能撤销已承诺valid；Shell持续接收cfg_rsp/cpl/必要event。未启动的已提交槽在drain安全discard，已接受任务执行或依binding取消。全部义务清空才drain_ack。

正常reset_req在drain_ack或隔离恢复证明后发起；reset_ack是复位结束，不表示AXI撤销。isolate_ack只证明约定范围屏障，不能自动释放buffer。超时进入平台恢复，epoch只拒收旧反馈，不阻止旧写；未收敛前保持资源。clock_gate_ok禁用时保守0，启用时需quiescent和明确唤醒条件。

## 7. 交付及验证边界

六个家族core独立，聚合core单向依赖六个家族，避免重复编译和循环；无假想`hac_if.interface.yaml`。1.0只编译契约生成的参数化interface，旧package/SVA已归档。flat工具当前为占位，views.flattened=false，不发布为可用连接视图。IP-XACT为工具输出的辅助描述，不代表完整工具互操作验证。

Schema、profile引用、逐字视图漂移和VCS接口elaboration结果见[验证记录](validation_1.0.md)。配置覆盖、任务/tag集合、取消竞态、迟到响应、排空/复位、CDC及真实组合性能仍需协议实现和VIP验证，不能凭本契约宣称qualified。
