# tests/schema

YAML Schema 正向与负向测试。

- 正向：合法的 Contract/Profile/Binding/Compatibility/Release Manifest 通过校验；
- 负向：非法 ID、缺失必填字段、非法方向、非法宽度表达式等被拒绝。

## 运行

```bash
python3 tools/contract_validate/contract_validate.py \
  --schema schema/interface_contract.schema.yaml \
  --contract tests/schema/data/ready_valid.positive.yaml
```
