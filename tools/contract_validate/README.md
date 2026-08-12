# contract_validate — YAML Contract 校验器

校验 Interface Contract / Profile / Binding / Compatibility / Release Manifest 是否符合 `schema/` 下的 JSON Schema。

## 依赖

- Python 3.8+；
- 可选：`pyyaml`、`jsonschema`（未安装时退化为基础结构检查）。

## 用法

```bash
# 校验单个 contract
python3 tools/contract_validate/contract_validate.py \
  --schema schema/interface_contract.schema.yaml \
  --contract foundation/ready_valid/contract/ready_valid.interface.yaml

# 批量校验（递归查找 *interface.yaml / *.profile.yaml）
python3 tools/contract_validate/contract_validate.py --all
```

## 退出码

- `0`：全部通过；
- `1`：存在校验失败。

## 说明

- 本工具是 CI「YAML 格式和 Schema 校验」门禁的入口；
- Schema 文件见 [`schema/`](../../schema/README.md:1)。
