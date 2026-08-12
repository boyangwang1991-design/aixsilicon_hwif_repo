# VIP Binding（bindings/vip）

描述接口到 VIP 的绑定映射，供 UVM Verification Skill 自动选择 VIP。

## 资产

- 示例：[`example_axi_lite_binding.yaml`](example_axi_lite_binding.yaml:1)
- Schema：`schema/binding.schema.yaml`
- 集成说明：`docs/integration-guide/README.md`

## 原则

- `role_map` 将统一角色映射到 VIP 原生角色（如 `initiator -> active_master`）；
- `sv_interface` 指明 VIP 使用的 SV interface 名；
- 协议 SVA/Checker/Coverage 属于 VIP Repo，本仓只描述绑定映射。
