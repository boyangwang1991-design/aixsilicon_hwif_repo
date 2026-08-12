# IP-XACT Binding（bindings/ipxact）

描述 Interface YAML → IP-XACT busDefinition / abstractionDefinition 的派生映射。

## 原则

- IP-XACT 是**派生交换视图**，不取代 YAML SSOT；
- 由 `tools/view_generate/` 生成，禁止反向手改后覆盖 YAML；
- 生成物用于 Cadence / Synopsys / 第三方集成工具交换；
- SystemRDL 仍是 CSR 主源，IP-XACT memoryMap 需要时由 SystemRDL 派生。

## 参考

- Accellera IP-XACT：https://www.accellera.org/downloads/standards/ip-xact
