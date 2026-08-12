# apb_target — APB target 最小消费者（示例）

展示一个 IP 如何通过 FuseSoC 依赖 `aix:interface:apb` 并使用 View A（packed struct）。

## 结构

```text
apb_target/
├── README.md
├── rtl/
│   └── apb_target_example.sv   # 消费 apb_req_t / apb_rsp_t
└── apb_target_example.core
```

## 状态

- 生命周期：`draft`；示例骨架已就位，RTL 待补齐。
