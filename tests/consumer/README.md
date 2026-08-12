# tests/consumer

IP / CBB / VIP / SoCGen 消费者测试。

- IP 消费者：IP 通过 FuseSoC 依赖接口 Core 并成功编译；
- VIP 消费者：VIP 通过 binding 正确装配（role_map / sv_interface）；
- SoCGen 消费者：接口 ID 解析、Role 匹配、Profile 协商、参数求值、域检查；
- 每个接口族达到 `qualified` 前必须至少一个 IP、一个 VIP、一个 SoCGen 示例消费。
