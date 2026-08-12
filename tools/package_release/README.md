# package_release — Release 包生成与 Catalog 发布

生成正式 Release 包并发布到 Unified Catalog。

## Release 包内容（对应 plan 第 18.3 节）

- YAML Contract/Profile/Compatibility；
- SystemVerilog package/interface/flat view；
- FuseSoC 发布态 Core；
- Interface Spec / Integration Guide / Migration Guide；
- Release Manifest 与 SBOM；
- Quality Report；
- 源码、生成器、依赖和工具 hash；
- Compatibility fingerprint。

## 状态

- 待建设；Manifest Schema 见 `schema/release_manifest.schema.yaml`。
