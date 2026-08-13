# HAC-IF 协议规格

> Hardware Accelerator Core Interface — 协议规格（草案 V0.1）
> 立项输入参见 [`digest/hwif.md`](../../../../../digest/hwif.md:1)。本文为 HWIF Repo 侧提炼的接口事实，供 Contract / RTL / SVA / VIP / CBB 共同消费。

## 1. 范围

本文定义 HAC-IF 的逻辑接口族、握手与事务语义、状态编码与配置 SSOT 约定。它**不**定义系统侧协议实现细节（AXI/CHI/NoC 由 CBB Adapter 负责），也**不**定义算法内容（由 IP Repo 的 HAC Core 负责）。

## 2. 逻辑接口族

| 接口族 | 定位 | 必须性 |
|---|---|---|
| `HAC-CTRL` | 任务启动、接收、完成和取消 | P0 及以上必选 |
| `HAC-STREAM` | 流式输入输出 | 按 Profile 可选 |
| `HAC-MEM` | 面向系统地址空间的访存请求/响应 | 按 Profile 可选 |
| `HAC-LMEM` | 本地 SRAM/Scratchpad 访问 | 可选 |
| `HAC-EVENT` | 完成、错误、性能及中断事件 | P0 及以上必选 |
| `HAC-MGMT` | 复位、功耗、隔离、调试和生命周期 | 推荐 |

## 3. 握手与不变量

所有接口族采用 `valid/ready` 同周期握手，并遵循以下全局不变量：

1. `valid=1 && ready=0` 时，全部 Payload 必须保持稳定；
2. 被接收且未被复位终止的任务，最终必须产生一次完成响应（或显式超时）；
3. `job_id` 在未完成任务集合中必须唯一；
4. `tag` 在完成前不得重用；不同 `tag` 允许乱序，同一 `tag` 内保持顺序；
5. `quiescent` 表示无未完成访存、流事务和待发送事件；
6. 不支持的输出不得保持 `X` 或悬空，可选输入必须明确 Tie-off。

## 4. HAC-CTRL

任务控制接口，将 Xilinx `ap_ctrl_hs` 的启动/完成模型扩展为可携带 `job_id`、`opcode`、`descriptor` 和错误状态的事务接口。

基线通道：

- 命令通道：`cmd_valid/cmd_ready/cmd_job_id/cmd_opcode/cmd_desc_addr/cmd_flags`
- 完成通道：`cpl_valid/cpl_ready/cpl_job_id/cpl_status`
- 取消通道：`cancel_valid/cancel_ready/cancel_job_id`
- 状态：`busy / idle / quiescent`

状态码分区：

| 范围 | 类型 |
|---|---|
| `0x0000` | 成功 |
| `0x0001–0x00FF` | 参数/Descriptor 错误 |
| `0x0100–0x01FF` | 访存和总线错误 |
| `0x0200–0x02FF` | 计算和数据格式错误 |
| `0x0300–0x03FF` | ECC/Parity/硬件故障 |
| `0x0400–0x04FF` | 超时、取消、看门狗 |
| `0x8000–0xFFFF` | 厂商或算法扩展 |

## 5. HAC-STREAM

流式数据接口。基线信号：`valid/ready/data/keep/last/id/user`。

语义要求：

- 标准 `valid/ready` 同周期握手，被背压时 `valid` 及 Payload 保持稳定；
- `keep` 按 Byte 有效，非包模式可裁剪；
- `last` 标识帧、包、Tensor Tile 或任务数据边界；
- `id` 可关联任务、Virtual Channel 或数据流；
- `user` 只承载协议已定义的旁带字段，禁止无文档私用；
- 支持独立输入和输出通道，不定义双向单通道。

## 6. HAC-MEM

面向加速器的抽象 Request/Response 接口，表达"读写什么"，不暴露 AXI 的 AR/AW/W/R/B 通道组织。

四条逻辑通道：Read Request、Read Response、Write Request/Data、Write Response。

V1.0 强制约束：

- 地址按 Byte 编址，`len_bytes` 表示整个请求的有效 Byte 数；
- 相同 `tag` 在完成前不得重用；
- 允许不同 `tag` 响应乱序，同一 `tag` 内保持顺序；
- 写数据不得早于对应 Write Request 被接受，除非扩展明确允许；
- 是否支持非对齐、跨页、大请求拆分由 Capability 声明；
- Core 只接收抽象状态，不直接处理 AXI `BRESP/RRESP`。

地址模型：

| 模式 | Core 看到的地址 | 场景 |
|---|---|---|
| Physical/IOVA 模式 | 系统地址或已转换 IOVA | 常规 SoC、SMMU 前置 |
| Window Offset 模式 | Buffer 窗口内偏移 | 强隔离、小型 HAC |

## 7. HAC-LMEM

本地存储接口，面向 Scratchpad SRAM、Weight/Activation Buffer、Line Buffer、多 Bank 共享存储及外置 ECC SRAM Wrapper。

两类 Profile：

- `LMEM-FIXED`：固定 1 或 2 周期返回，紧耦合单 Bank SRAM；
- `LMEM-DECOUPLED`：请求/响应解耦，仲裁、多 Bank、可变延迟存储。

原则上 HAC Core 不直接绑定 Foundry Macro 端口，由 `LMEM Adapter` 完成 Macro 适配、ECC 与修复控制。

## 8. HAC-EVENT

事件采用 `valid/ready + event payload`，中断由 Shell 根据事件策略生成。

事件字段：`event_type / severity / source / job_id / code / info`。

事件分类：

| 类型 | 示例 |
|---|---|
| Completion | 任务完成、阶段完成 |
| Recoverable Error | 参数错误、可恢复 ECC、输入欠载 |
| Fatal Error | 不可恢复 ECC、状态机失控、内部一致性错误 |
| Performance | Counter 溢出、阈值触发 |
| Security | 非法地址、权限错误、完整性错误 |
| Debug | Trace 触发、断点、快照完成 |

中断策略：

- Core 不直接产生面向 CPU 的中断协议，由 Shell 将事件映射到 IRQ/MSI；
- 支持中断聚合、屏蔽、节流、W1C 状态；
- 错误事件在被消费前不得静默丢失；
- Fatal 事件应有独立粘滞状态，软复位不得默认清除诊断证据。

## 9. HAC-MGMT

管理接口，定义复位与生命周期、低功耗、调试与性能语义。

- `reset_req/reset_ack`：受控软复位；
- `drain_req/drain_ack`：停止接收新任务并排空；
- `quiescent`：可安全关钟/断电；
- `isolate_req/isolate_ack`：隔离握手；
- `fatal_state`：需要系统级恢复。

## 10. 配置 SSOT

HAC-IF 配置以 YAML 为 SSOT（示例见 [`schema/hac_if.schema.json`](../schema/hac_if.schema.json:1)），由工具生成 SystemVerilog 参数包、Interface 实例、FuseSoC `.core`、SystemRDL 寄存器实例、C Header、UVM Agent 配置、Protocol Checker/SVA 绑定与接口文档。

版本规则：`MAJOR.MINOR`；MAJOR 为不兼容信号或事务语义变更，MINOR 为增加可选字段/Capability 或兼容行为。

## 11. 验证基线

必须提供的 SVA：

- 背压期间 Payload 稳定；
- Job ID 唯一；
- Tag 不提前复用；
- 每个请求最终完成或明确超时；
- 完成不能无对应命令；
- `quiescent` 时无 Outstanding；
- Reset 后输出进入定义状态；
- 不支持的 Capability 不得产生相关事务。
