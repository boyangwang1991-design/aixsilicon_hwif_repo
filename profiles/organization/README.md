# 组织级 Profile（organization）

Profile 是经评审冻结的参数/能力组合。首批定义（对应 plan 第 12.2 节）：

| Profile | 接口族 | 状态 |
|---|---|---|
| `apb_csr_v1` | apb | 待定义 |
| `axi_lite_csr_v1` | axi_lite | ✅ [`bus/axi_lite/contract/axi_lite_csr.profile.yaml`](../../bus/axi_lite/contract/axi_lite_csr.profile.yaml:1) |
| `axi_memory_basic_v1` | axi | ✅ [`bus/axi/contract/axi4_base.profile.yaml`](../../bus/axi/contract/axi4_base.profile.yaml:1) |
| `axi_dma_high_bw_v1` | axi | 待定义 |
| `axi_stream_basic_v1` | axi_stream | 待定义 |
| `axi_stream_packet_v1` | axi_stream | ✅ [`bus/axi_stream/contract/axi_stream_packet.profile.yaml`](../../bus/axi_stream/contract/axi_stream_packet.profile.yaml:1) |
| `ready_valid_scalar_v1` | ready_valid | 待定义 |
| `ready_valid_packet_v1` | ready_valid | 待定义 |
| `credit_link_basic_v1` | credit_link | ✅ [`link/credit_link/contract/credit_link_basic.profile.yaml`](../../link/credit_link/contract/credit_link_basic.profile.yaml:1) |
| `interrupt_level_v1` | interrupt | 待定义 |
| `interrupt_pulse_v1` | interrupt | 待定义 |
| `memory_1rw_sync_v1` | memory_1rw | 待定义 |
| `safety_event_v1` | safety_event | ✅ [`safety_security/safety_event/contract/safety_event_v1.profile.yaml`](../../safety_security/safety_event/contract/safety_event_v1.profile.yaml:1) |

## 治理原则

- Profile 应**少而稳定**；
- 项目专用参数放在 IP/SoC 配置中，**不要**为每个项目新增公共 Profile；
- Profile 只能引用基础接口 ID，不得复制基础接口信号；
- 新 Profile 需架构/协议评审（成熟度至少 `reviewed`）后发布。
