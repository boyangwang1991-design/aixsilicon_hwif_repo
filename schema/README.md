# schema — 接口 Schema

本目录定义接口契约体系的 JSON Schema（YAML 表示）。

| Schema | 用途 |
|---|---|
| [`interface_contract.schema.yaml`](interface_contract.schema.yaml:1) | 接口语义唯一事实源（SSOT） |
| [`interface_profile.schema.yaml`](interface_profile.schema.yaml:1) | Profile（能力/参数冻结组合） |
| [`binding.schema.yaml`](binding.schema.yaml:1) | VIP / IP-XACT / Legacy 绑定映射 |
| [`compatibility.schema.yaml`](compatibility.schema.yaml:1) | 兼容性规则与结论 |
| [`release_manifest.schema.yaml`](release_manifest.schema.yaml:1) | Release 包元数据 |

## 校验

```bash
python3 tools/contract_validate/contract_validate.py \
  --schema schema/interface_contract.schema.yaml \
  --contract foundation/ready_valid/contract/ready_valid.interface.yaml
```

## 原则

- Schema 变更属于破坏性变更，需升 Major 并更新版本；
- Schema 校验是 G0 Contract Gate 的入口。
