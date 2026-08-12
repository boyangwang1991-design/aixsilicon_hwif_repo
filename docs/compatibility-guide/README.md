# 兼容性指南

> 三层兼容性模型与自动判定。详细规划见 [`plan.md`](plan.md:766) 第 13 节。

## 1. 三层兼容性

| 层次 | 判断内容 | 结果示例 |
|---|---|---|
| Protocol Compatibility | 是否属于同一协议族和兼容规范版本 | AXI4 ↔ AXI4 |
| Profile Compatibility | 必选能力、可选信号和参数是否匹配 | target 不支持 ATOP |
| Binding Compatibility | 具体端口、role、clock/reset/power 是否可绑定 | DataWidth 不一致 |

## 2. 自动判定结论（唯一三类）

- `DIRECT`：可直接连接；
- `ADAPTER_REQUIRED`：语义可转换，但需要明确的 CBB adapter；
- `INCOMPATIBLE`：不允许自动连接。

**不能以「端口名相同」作为 DIRECT 依据。**

## 3. 典型规则

| 条件 | 结论 |
|---|---|
| 协议和 Profile 一致，参数一致 | DIRECT |
| AXI 数据位宽不同 | ADAPTER_REQUIRED |
| AXI ID 宽度不同且可证明截断/扩展安全 | ADAPTER_REQUIRED |
| Clock domain 不同 | ADAPTER_REQUIRED |
| Reset polarity 不同 | ADAPTER_REQUIRED 或绑定层转换 |
| Source 要求 ATOP，Target 不支持 | INCOMPATIBLE |
| Source 可能产生 8 个 Outstanding，Target 只接受 1 个且无节流保证 | ADAPTER_REQUIRED 或 INCOMPATIBLE |
| Stream 有 TLAST，Sink 不理解 packet boundary | INCOMPATIBLE，除非显式 strip adapter |
| Interrupt pulse 连接到只接受 level 的 receiver | ADAPTER_REQUIRED |
| Safety event severity 语义不一致 | INCOMPATIBLE |

## 4. SoCGen 集成前检查（10 步）

1. Interface ID 解析；
2. Role 匹配；
3. Profile 协商；
4. 参数求值；
5. Clock/reset/power domain 检查；
6. Capability 检查；
7. Adapter 需求识别；
8. 未连接和 tie-off 规则检查；
9. 生成兼容性报告；
10. 将实际 Interface 版本写入 SoC Lockfile。

Compatibility Checker 识别出 `ADAPTER_REQUIRED` 后，只能从 Catalog 选择满足转换条件的
**已发布 CBB**，不允许 SoCGen 临时生成未经验证的转换逻辑。

## 5. 相关 Schema

- 规则与结论：`schema/compatibility.schema.yaml`
- 用例：`tests/compatibility/`
- 工具：`tools/compatibility_check/`
