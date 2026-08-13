# impact_analysis — 变更影响分析

分析接口变更对 IP / CBB / VIP / SoC 的影响范围。

## 实现

- 扫描所有 `.core` 的 `depend`（`aix:interface:<family>:` 依赖）得到跨接口依赖；
- 从契约 `interface.family`（SSOT）枚举全部接口族；
- 汇总直接消费者：core、`bindings/`、`examples/`、`tests/consumer/`。

## 用法

```bash
# 分析某接口族的影响面
python3 tools/impact_analysis/impact_analysis.py --family axi

# 列出全部接口族及其消费者数量
python3 tools/impact_analysis/impact_analysis.py --all
```

## 输出

- 修改一个 typedef / 信号 / 能力后，受影响的消费者清单；
- 依赖它的其他接口 core（间接影响面）；
- 兼容性影响摘要（与 `compatibility_check` 联动）。

## 状态

- 已实现依赖与消费者扫描；入口可接入 PR CI 与 AIXSILICON 影响分析页面；
- 待扩展：版本漂移 / Deprecated 报告、typedef 级影响追踪（结合 `sv_consistency_check`）。
