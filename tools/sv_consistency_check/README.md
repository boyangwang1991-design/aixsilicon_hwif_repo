# sv_consistency_check — SV 与 YAML 一致性检查器

对照 YAML Contract 检查 SV package/interface/flat wrapper 的一致性。

## 检查内容

- 信号名、宽度表达式与方向与 YAML 一致；
- 必选/可选属性与 capability 一致；
- packed struct 位布局与 YAML 宽度表达式一致；
- tie-off/default 与 YAML 一致；
- 生成器输出 type fingerprint，防止同名异构类型混入工程。

## 状态

- 待建设；入口将接入 PR CI「生成视图是否为最新」门禁。
