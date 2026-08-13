# tests/schema

YAML Schema 正向与负向测试。

- 正向（`*.positive.yaml`）：合法 Contract/Profile/Binding/Compatibility/Release Manifest 必须通过校验；
- 负向（`*.negative.yaml`）：非法 ID、缺失必填字段、非法 handshake 等必须被拒绝。

## 用例

| 文件 | 类型 | 覆盖点 |
|---|---|---|
| [`data/ready_valid.positive.yaml`](data/ready_valid.positive.yaml) | contract 正向 | 合法契约通过 |
| [`data/bad_id.negative.yaml`](data/bad_id.negative.yaml) | contract 负向 | 非法稳定 ID 被拒 |
| [`data/missing_required.negative.yaml`](data/missing_required.negative.yaml) | contract 负向 | 缺失 `channels` 被拒 |
| [`data/bad_handshake.negative.yaml`](data/bad_handshake.negative.yaml) | contract 负向 | 非法 handshake 值被拒 |

## 运行

```bash
# 单个用例
python3 tools/contract_validate/contract_validate.py \
  --schema schema/interface_contract.schema.yaml \
  --contract tests/schema/data/ready_valid.positive.yaml

# 全部正/负向用例
python3 tests/schema/run_schema_tests.py
```

退出码 `0` 表示全部通过。
