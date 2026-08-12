# Legacy Binding（bindings/legacy）

描述历史/第三方 IP 的端口命名与统一契约的映射（`m_*` / `s_*` 别名等）。

## 原则

- 统一角色以 `initiator/target`、`source/sink` 为准；
- `m_`/`s_` 等历史前缀仅作为**别名**记录在 metadata 中，不视为新接口类型；
- 遗留别名映射必须经兼容性检查，避免「端口名相同」误判为 DIRECT。
