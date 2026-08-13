# HAC-IF Examples

> 消费者/接入示例。具体 HAC 实现（算法核、Wrapper、Descriptor）归 `ip-repo`；此处只放接口消费与连接示例。

## 建议首批参考实现（Golden Examples）

| Example | Profile | 说明 |
|---|---|---|
| A：小型 AES/CRC 核 | P0 | CSR 直接配置，`ap_ctrl_hs` Wrapper，验证控制接口与轻量 Shell 面积 |
| B：流式 FIR/Video Filter | P1 | 输入/输出 HAC-STREAM，AXI4-Stream Adapter，验证连续吞吐、随机背压、帧边界 |
| C：Conv2D/GEMM 核 | P2/P3 | Descriptor、双 HAC-MEM 端口、多 Outstanding、DDR 读写，验证复杂任务、带宽与 PPA |

只有当三类 Example 均无需破坏基础协议即可接入，才建议冻结 HAC-IF V1.0。

## 待添加

- `hac_p0_aes_crc.core`：接入 `aix:interface:hac_ctrl` + `aix:interface:hac_event`；
- `hac_p1_fir.core`：接入 `hac_ctrl` + `hac_stream` + `hac_event`；
- `hac_p2_conv2d.core`：接入 `hac_ctrl` + `hac_mem` + `hac_event`。
