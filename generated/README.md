# generated — 派生视图（禁止手工修改）

本目录存放由 `tools/` 生成的派生视图，**禁止手工修改**。

| 子目录 | 内容 |
|---|---|
| `docs/` | 由 YAML Contract 生成的接口文档 |
| `ipxact/` | 由 YAML 生成的 IP-XACT busDefinition / abstractionDefinition |
| `catalog/` | 统一 Catalog 索引（接口版本、Profile、消费者、质量状态） |

## 原则

- 派生文件一致性由 CI 检查（「生成视图是否为最新」门禁）；
- 是否将生成文件提交 Git，由后续 CI 与红区工具可用性决定；
- 正式 Release 包**必须包含生成结果**，避免消费者被迫安装生成器；
- 生成器确定性要求：同输入必须产生相同 hash。
