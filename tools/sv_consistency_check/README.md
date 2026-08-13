# sv_consistency_check — SV 与 YAML 一致性检查器

对照 Interface Contract（YAML SSOT）检查 SV interface 视图的信号一致性。

## 检查内容

- 契约中 `required` 的信号必须出现在对应 SV interface 声明中；
- 契约中可选信号（capability）若 SV 未实现，输出 WARN（允许，视为未启用该能力）；
- SV 中出现但契约未声明的信号，输出 WARN（提示冗余或命名不一致）；
- `clk`/`rst_n` 等由 interface 端口提供的系统信号自动跳过。

## 用法

```bash
# 检查单个契约与其 SV interface
python3 tools/sv_consistency_check/sv_consistency_check.py \
  --contract bus/axi/contract/axi.interface.yaml \
  --rtl bus/axi/rtl/aix_axi_if.sv

# 全库扫描（契约位于 <family>/contract/，SV 位于 <family>/rtl/）
python3 tools/sv_consistency_check/sv_consistency_check.py --all --root .
```

## 退出码

- `0`：无错误（可能有 WARN）；
- `1`：存在缺失的 required 信号或缺失 SV interface。

## 说明

- 本工具是 CI「生成视图是否为最新 / SV 与契约一致」门禁的入口；
- 依赖 `pyyaml`（契约解析）与 Python 正则（SV 信号提取）。
