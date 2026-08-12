# compatibility_check — 兼容性判定器

根据三层兼容性模型输出唯一三类结论：`DIRECT` / `ADAPTER_REQUIRED` / `INCOMPATIBLE`。

## 判定流程

1. Protocol Compatibility：同一协议族 + 兼容规范版本；
2. Profile Compatibility：必选能力、可选信号、参数匹配；
3. Binding Compatibility：端口、role、clock/reset/power 绑定。

## 规则

- 不能以「端口名相同」作为 DIRECT 依据；
- `ADAPTER_REQUIRED` 只能引用 Catalog 中已认证的 CBB Adapter；
- 不兼容连接必须显式失败，禁止 SoCGen 静默截位/绑常量。

## 状态

- 待建设；Schema 见 `schema/compatibility.schema.yaml`，用例见 `tests/compatibility/`。
