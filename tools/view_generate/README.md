# view_generate — 派生视图生成器

从 YAML Contract 确定性生成派生视图。

## 当前实现

- **SV interface / modport（View B）**：按契约 channel/signal 生成内部 logic 与按角色聚合的 modport；
  契约 `parameters` 映射为 SV 参数（uint/int → `int unsigned`、bool → `bit`、enum → `string`）；
  纯数字宽度 `N` 映射为 `[N-1:0]`，参数/表达式宽度原样保留；
  确定性输出并给出 sha256。

## 用法

```bash
# 生成全部接口的 SV 视图到 generated/
python3 tools/view_generate/view_generate.py --all --root . --out generated

# 单个契约
python3 tools/view_generate/view_generate.py \
  --contract foundation/ready_valid/contract/ready_valid.interface.yaml --out generated

# 额外生成 IP-XACT（plan §20）
python3 tools/view_generate/view_generate.py --all --root . --out generated --ipxact

# 额外生成 Flat Port Wrapper（View C，plan §6.4）
python3 tools/view_generate/view_generate.py --all --root . --out generated --flat

# 额外生成 Interface Spec（markdown）
python3 tools/view_generate/view_generate.py --all --root . --out generated --docs

# CI 门禁：校验生成视图是否为最新（改契约后需重新生成）
python3 tools/view_generate/view_generate.py --all --root . --out generated --check-only
```

## 原则

- 确定性：同输入必产生相同 hash；
- 生成物进入 `generated/`，禁止手工修改；
- 发布态 Core 由流水线生成，禁止手工维护。

## 状态

- 已实现 View B 生成与 `--check-only` 门禁；
- 已实现 IP-XACT busDefinition / abstractionDefinition（`--ipxact`，112 个 XML 校验通过）；
- 已实现 Flat Port Wrapper（View C，`--flat`，56 个编译通过）；
- 已实现 Interface Spec 文档（`--docs`，56 个 markdown）；
- 待扩展：type fingerprint 与 manifest 片段。
