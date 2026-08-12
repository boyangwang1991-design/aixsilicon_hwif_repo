# examples — 消费者示例

提供 IP / CBB / VIP / SoCGen 消费接口契约的最小示例。

| 示例 | 内容 | 状态 |
|---|---|---|
| [`apb_target/`](apb_target/README.md:1) | APB target 最小消费者（IP 视角） | 骨架 |
| `axi_roundtrip/` | AXI struct↔interface↔flat roundtrip | 待建设 |
| `vip_consumer/` | VIP 绑定消费示例 | 待建设 |
| `socgen_consumer/` | SoCGen 接口解析示例 | 待建设 |

## 原则

- 每个示例都应可编译，并可作为 `tests/consumer/` 的输入；
- 示例只能通过 FuseSoC 依赖声明消费接口 Core，不复制接口类型定义。
