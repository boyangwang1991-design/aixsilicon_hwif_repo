# HAC-STREAM — 流式数据接口

> 高吞吐流式输入输出，支持独立输入和输出通道，按 Profile 可选（P1/P3）。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/hac_stream.interface.yaml`](contract/hac_stream.interface.yaml:1) |
| SV Package | [`rtl/aix_hac_stream_pkg.sv`](rtl/aix_hac_stream_pkg.sv:1) |
| SV Interface | [`rtl/aix_hac_stream_if.sv`](rtl/aix_hac_stream_if.sv:1) |
| FuseSoC Core | [`aix_interface_hac_stream.core`](aix_interface_hac_stream.core:1) |

## 基线信号

- `valid/ready/data/keep/last/id/user`

## 语义要点

- 标准 `valid/ready` 同周期握手；
- 被背压时 `valid` 及 Payload 保持稳定；
- `keep` 按 Byte 有效，非包模式可裁剪；
- `last` 标识帧、包、Tensor Tile 或任务数据边界；
- `id` 可关联任务、Virtual Channel 或数据流；
- `user` 只承载协议已定义的旁带字段，禁止无文档私用；
- 支持独立输入和输出通道，不定义双向单通道；
- 不要求与 AXI4-Stream 信号名称相同，但基础语义应可直接映射。

## 推荐扩展

- Packet 模式；Fixed-frame 模式；
- Tensor 元数据扩展（shape、dtype、tile index）；
- Credit-based Adapter；多虚通道；CRC/Parity 旁带状态。
