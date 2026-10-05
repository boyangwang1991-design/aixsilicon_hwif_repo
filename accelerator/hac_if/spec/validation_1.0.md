# HAC-IF 1.0 draft 验证记录

核查日期：2026-10-04。输入为本地工作树，未发布、未改变lifecycle。可审查结果摘要与输入SHA-256见 [validation_1.0.json](validation_1.0.json)，派生视图指纹见 [views.sha256.json](../views.sha256.json)。原始运行产物位于HWIF仓库`build/hac_contract/`，不作为源文件提交。

| 检查 | 结果 | 范围与限制 |
|---|---|---|
| Contract schema | PASS，6份 | 仓库现行interface_contract.schema.yaml，未改schema |
| Profile schema及引用 | PASS，3份 | 仅引用所属族的能力/参数，版本匹配 |
| AXIS静态Binding | PASS，1份 | binding schema、源信号和producer方向；无adapter实现 |
| 可选线及唯一信号 | PASS | 无重复声明，from/to合法，可选字段有capability/tieoff；interface无assign |
| 派生视图漂移 | PASS，24份 | 临时重新生成并逐字比较：6 SV、6文档、12 XML；指纹匹配 |
| 标准HWIF SV consistency | PASS，6族，0 warning | 使用统一hwif_tool逐族检查；附加本地modport逐信号方向检查 |
| FuseSoC结构 | PASS，7 core | FuseSoC实际发现/解析七个1.0 core，归档0.1未发现；所有target/fileset引用、文件存在、依赖闭合且无环；不是实际消费者构建 |
| XML | PASS | well-formed语法检查；无完整IP-XACT schema/第三方导入验证 |
| Schema负向样例 | PASS，3个拒绝 | 非法接口名、数字零宽表达式、非法SemVer |
| VCS编译/elaboration及smoke | PASS | W-2024.09-SP1，6族×默认/最小/较宽=18实例，两个role modport均接入，逐信号$bits检查 |

VCS smoke只给端点输出常量并检查结构，没有实现任务处理、ready/valid状态机或系统访存行为。VCS报告存在端口coerced-to-inout的notice；modport方向另按YAML逐信号检查。本报告不将该notice等同协议错误或宣称行为门禁通过。

本版未覆盖：配置覆盖和槽生命周期、完成反压与一次性、取消竞态、tag复用/乱序/迟到响应、MEM真实多拍与AXI错误、LMEM真实宏时序/ECC、排空/复位/隔离、event保留/丢弃、CDC/RDC、真实算法组合、uDMA/HTS运行绑定及PPA。这些由IP/CBB/VIP对应owner完成后，才可提升相关实现或profile成熟度。flat占位和旧SVA不进入验证支持范围。

## 复现

从workflow根目录运行：

```bash
uv run python repos/aixsilicon_hwif_repo/accelerator/hac_if/scripts/sync_views.py --check
uv run python repos/aixsilicon_hwif_repo/accelerator/hac_if/scripts/check_contracts.py --vcs
```

另可直接验证core发现和CAPI解析：

```bash
uv run fusesoc --cores-root=repos/aixsilicon_hwif_repo/accelerator/hac_if core list
```

`sync_views.py --tool /path/to/hwif_tool.py`可指定统一生成器位置。标准consistency命令的`--contract`和`--rtl`使用绝对路径，避免wrapper切换工作目录后相对路径失效：

```bash
uv run python /home/eda/.codex/skills/hwif-development-suite/scripts/hwif_tool.py consistency \
  --contract /home/eda/workspace/aixsilicon_workflow/repos/aixsilicon_hwif_repo/accelerator/hac_if/hac_ctrl/contract/hac_ctrl.interface.yaml \
  --rtl /home/eda/workspace/aixsilicon_workflow/repos/aixsilicon_hwif_repo/accelerator/hac_if/hac_ctrl/rtl/aix_hac_ctrl_if.sv
```

对stream/mem/lmem/event/mgmt重复对应路径。输入变化后重跑并更新证据；不能沿用旧指纹宣称新输入PASS。
