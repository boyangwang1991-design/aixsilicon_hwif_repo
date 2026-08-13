# package_release — Release 包生成与 Catalog 发布

为指定接口族生成正式 Release 包（对应 plan §18.3）。

## Release 包内容

`<out>/<family>_<version>/` 下包含：

- `contract/`：YAML Contract / Profile；
- `rtl/`：SystemVerilog package / interface / wrapper；
- `<family>.core`：FuseSoC 发布态 Core；
- `release_manifest.yaml`：Manifest（SemVer、资产、sha256、quality、provenance、fingerprint）；
- `quality_report.json`：质量报告（G0/G2/G5 快照）。

## 用法

```bash
# 预览（不写文件）
python3 tools/package_release/package_release.py --family axi --version 1.0.0 --dry-run

# 生成正式包（含 Unified Catalog 条目与 SoC Lockfile）
python3 tools/package_release/package_release.py --family axi --version 1.0.0 \
  --out release/ --catalog --lockfile

# 校验 manifest 符合 schema
python3 tools/contract_validate/contract_validate.py \
  --schema schema/release_manifest.schema.yaml \
  --contract release/axi_1.0.0/release_manifest.yaml
```

## 状态

- 已实现：资产收集、Manifest/Quality 生成、`--dry-run` 预览、Unified Catalog 条目（`--catalog`）、SoC Lockfile（`--lockfile`）；
- 待扩展：SBOM、FuseSoC Catalog 正式发布、Deprecated 迁移包。
