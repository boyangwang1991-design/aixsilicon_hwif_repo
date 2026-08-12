# tools — 工具链

按 plan 第 8 节组织的工具集。

| 工具 | 用途 | 状态 |
|---|---|---|
| [`contract_validate/`](contract_validate/README.md:1) | YAML Contract/Profile/Binding Schema 校验 | ✅ 可用 |
| [`sv_consistency_check/`](sv_consistency_check/README.md:1) | SV package/interface 与 YAML 一致性检查 | 待建设 |
| [`view_generate/`](view_generate/README.md:1) | 派生视图生成（SV interface/flat/IP-XACT/文档） | 待建设 |
| [`compatibility_check/`](compatibility_check/README.md:1) | 兼容性判定（DIRECT/ADAPTER_REQUIRED/INCOMPATIBLE） | 待建设 |
| [`impact_analysis/`](impact_analysis/README.md:1) | 变更影响分析 | 待建设 |
| [`package_release/`](package_release/README.md:1) | Release 包生成与 Catalog 发布 | 待建设 |

## 原则

- 生成器必须是**确定性**的：同输入产生相同 hash；
- 所有工具输出可机器读取（JSON / YAML）；
- 工具版本纳入 Release Manifest 与 SoC Lockfile。
