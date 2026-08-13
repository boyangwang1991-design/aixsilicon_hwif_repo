# HAC-CTRL — 任务控制接口

> 将 Xilinx `ap_ctrl_hs` 的启动/完成模型扩展为可携带任务标识、Opcode、Descriptor 和错误状态的事务接口。P0 及以上 Profile 必选。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/hac_ctrl.interface.yaml`](contract/hac_ctrl.interface.yaml:1) |
| SV Package | [`rtl/aix_hac_ctrl_pkg.sv`](rtl/aix_hac_ctrl_pkg.sv:1) |
| SV Interface | [`rtl/aix_hac_ctrl_if.sv`](rtl/aix_hac_ctrl_if.sv:1) |
| FuseSoC Core | [`aix_interface_hac_ctrl.core`](aix_interface_hac_ctrl.core:1) |

## 基线信号

- 命令通道：`cmd_valid/cmd_ready/cmd_job_id/cmd_opcode/cmd_desc_addr/cmd_flags`
- 完成通道：`cpl_valid/cpl_ready/cpl_job_id/cpl_status`
- 取消通道：`cancel_valid/cancel_ready/cancel_job_id`
- 状态：`busy / idle / quiescent`

## 语义要点

- 命令在 `cmd_valid && cmd_ready` 时被接收；背压时命令 Payload 必须保持稳定；
- 每个被接收且未被复位终止的任务，最终必须产生一次完成响应；
- `job_id` 在未完成任务集合中必须唯一；
- 不支持多任务的实现应将 `max_inflight_jobs` 声明为 1；
- `idle` 表示无活动计算，`quiescent` 进一步表示无未完成访存、流事务和待发送事件。

## 状态码分区

| 范围 | 类型 |
|---|---|
| `0x0000` | 成功 |
| `0x0001–0x00FF` | 参数/Descriptor 错误 |
| `0x0100–0x01FF` | 访存和总线错误 |
| `0x0200–0x02FF` | 计算和数据格式错误 |
| `0x0300–0x03FF` | ECC/Parity/硬件故障 |
| `0x0400–0x04FF` | 超时、取消、看门狗 |
| `0x8000–0xFFFF` | 厂商或算法扩展 |

## Xilinx AP 兼容

定义 `hac_ap_ctrl_adapter`（CBB Repo）：`ap_start→cmd_valid`、`ap_done→cpl_valid`、`ap_idle→idle`；`ap_ctrl_hs/chain` 归单任务/顺序映射，`ap_ctrl_none` 归 Free-running 扩展，不伪造单任务完成语义。
