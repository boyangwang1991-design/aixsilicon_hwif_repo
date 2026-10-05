# HAC-MEM — 1.0 draft

接口唯一语义源为 [Contract](contract/hac_mem.interface.yaml)，信号及语义全文见 [派生规格](doc/aix_hac_mem_spec.md)。

可综合接口为 [SV view](rtl/aix_hac_mem_if.sv)，提供两个角色的 modport。可选线保留，由发送端按 binding 唯一驱动；关闭能力时使用契约 tieoff。修改 YAML 后在 workflow 根目录运行 `uv run python repos/aixsilicon_hwif_repo/accelerator/hac_if/scripts/sync_views.py`，禁止手改派生视图。

组合 profile、系统侧 binding 约束、版本迁移和验证边界见 [总规格](../spec/hac_if_spec.md)。旧 0.1 视图已归档，不在 1.0 fileset 中。
