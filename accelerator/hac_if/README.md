# HAC-IF — 1.0 draft

本版对齐 [最终 HAC 组织方案](../../../aixsilicon_ip_repo/ips/accelerator/hac_organization.md)，定义 Compute Engine / Wrapper-Shell / Cluster 的统一执行边界。uDMA 为统一系统搬运服务；Streamer 只负责本地供数。旧 0.1 契约存在不兼容变化，本版 SemVer 为 `1.0.0`、生命周期保持 `draft`。

- [总规格与集成规则](spec/hac_if_spec.md)
- [0.1 → 1.0 迁移及影响](spec/migration_1.0.md)
- [验证范围与复现](spec/validation_1.0.md)
- [聚合 FuseSoC core](interface_hac_if.core)

| 家族 | 统一职责 | Contract | 生成规格 |
|---|---|---|---|
| CTRL | 配置提交、启动、完成、取消 | [YAML](hac_ctrl/contract/hac_ctrl.interface.yaml) | [信号及语义](hac_ctrl/doc/aix_hac_ctrl_spec.md) |
| STREAM | AXIS兼容子集，数据及边界 | [YAML](hac_stream/contract/hac_stream.interface.yaml) | [信号及语义](hac_stream/doc/aix_hac_stream_spec.md) |
| MEM | 可选系统访存，读/写五通道 | [YAML](hac_mem/contract/hac_mem.interface.yaml) | [信号及语义](hac_mem/doc/aix_hac_mem_spec.md) |
| LMEM | 本地存储请求与响应 | [YAML](hac_lmem/contract/hac_lmem.interface.yaml) | [信号及语义](hac_lmem/doc/aix_hac_lmem_spec.md) |
| EVENT | 必要错误与可选完成镜像/统计 | [YAML](hac_event/contract/hac_event.interface.yaml) | [信号及语义](hac_event/doc/aix_hac_event_spec.md) |
| MGMT | 排空、受控复位、可选隔离/门控 | [YAML](hac_mgmt/contract/hac_mgmt.interface.yaml) | [信号及语义](hac_mgmt/doc/aix_hac_mgmt_spec.md) |

Contract YAML 是语义唯一真相源，profile 只冻结所属家族能力/参数，不复制信号。生成规格、SV interface、IP-XACT 为派生视图，由统一 HWIF 工具生成后逐字发布到本目录。当前 flat 生成器产物为占位，未列入支持视图；旧固定宽度 package / SVA 已 [归档](archive/0.1.0/README.md)，不参与 1.0 编译。

在 workflow 根目录执行：

```bash
uv run python repos/aixsilicon_hwif_repo/accelerator/hac_if/scripts/sync_views.py
uv run python repos/aixsilicon_hwif_repo/accelerator/hac_if/scripts/sync_views.py --check
uv run python repos/aixsilicon_hwif_repo/accelerator/hac_if/scripts/check_contracts.py
```

当前交付是契约与接口视图同步，不代表 Shell、Adapter、Checker、软件 ABI 或完整组合已资格验证。协议实现归 CBB/IP owner，协议验证组件归 VIP owner。
