# HWIF Development Suite + 唯一入口收敛规划

> 状态：`draft`（Change Plan 草案）
> 日期：2026-08-17
> 决策（用户确认）：
> **A) `aixsilicon_hwif_repo` 只保存 Contract SSOT 与生成结果（`contracts/` + `generated/`）；**
> **B) HWIF 全生命周期方法论（规格→契约→代码→验证→FuseSoC→发布）统一落在 `aixsilicon_skill_repo` 的 `hwif-development-suite`，内置全部确定性脚本（`contract_validate.py` / `view_generate.py` / `sv_consistency.py` / `compatibility_check.py` / `impact_analysis.py` / `package_release.py`），不再由 `aixsilicon_tool_repo` 承载 `aix-hwif-gen` 包。**
> 关联：Change Bundle [`CHG-2026-HWIF-001`](../../changesets/CHG-2026-HWIF-001.yaml)
> 依据：ADR-0006（工具归属与迁移）、ADR-0008（action capability preflight）、[`ownership-map.yaml`](../../ownership-map.yaml)

---

## 1. 目标

把 HWIF 的确定性与方法论能力收敛到 `hwif-development-suite`，**全程覆盖接口仓生命周期**，并贴合 `aixsilicon_hwif_repo` 现有目录结构：

```text
aixsilicon_hwif_repo（SSOT + 结果，人工只碰 contract/profile/binding）
   ├── bus/<family>/           e.g. bus/apb/: contract/*.yaml, rtl/aix_apb_*.sv, *.core
   ├── peripheral/ foundation/ dft_debug/ safety_security/ system/ memory/ common/
   │        └── <if>/  contract/ rtl/ *.core
   ├── bindings/               ipxact/ legacy/ vip/ 绑定映射
   ├── profiles/               organization/ project_extensions/ 组织级 Profile
   ├── schema/                 5 个 JSON Schema（SSOT 校验）
   ├── tests/                  schema/compile/compatibility/consumer
   ├── tools/                  ← T2 待收敛（迁移入 skill）
   └── generated/              ← 幂等产物（禁止手改）
        ├── catalog/ docs/ ipxact/
        └── <family>/<view>.sv

aixsilicon_skill_repo/skills/hwif-development-suite/   ← 方法 + 编排 + 内置脚本
   ├── SKILL.md                    # 生命周期路由 + 子 skill 路由表 + 冲突边界
   ├── skills/                     # 全生命周期 8 子 skill（见 §4.1）
   ├── references/                 # 按需加载规则
   ├── evals/                      # evals.json + trigger-query.json（skill-creator 方法论）
   └── tests/                      # 内置脚本 pytest

工具仓库 aixsilicon_tool_repo       ← 只保留整块独立产品工具（reg/schema/address-map/dvsim 等）
   └── packages/aix-hwif-gen       ← ADR-0006 阶段 B/C 收敛、deprecated，指向 hwif-development-suite
```

- **唯一执行入口**：`hwif-development-suite/scripts/`（经 `uv run` 触发）；
- **hwif 仓不再保存确定性实现**，只保存契约与结果；T2 工具收敛；
- **tool-repo 不再承载 `aix-hwif-gen`**。

## 2. 现状盘点（2026-08-17）

### 2.1 hwif 仓（`aixsilicon_hwif_repo`）真实结构

| 路径 | 内容 | 生成/维护方式 |
|---|---|---|
| `bus/{apb,axi,axi_lite,axi_stream,ahb_lite,obi,tilelink_ul}/` | 每家族：`contract/*.interface.yaml` + `*.profile.yaml`、`rtl/aix_*_if/pkg.sv`、`aix_interface_*.core`、README | 契约手写（SSOT）；SV/core 由生成器派生 + 人工审 |
| `peripheral/` `foundation/` `dft_debug/` `safety_security/` `system/` `memory/` `common/` `accelerator/` | 各接口族同上 | 同上 |
| `bindings/{ipxact,legacy,vip}/` | Binding 映射 YAML | 手写（契约） |
| `profiles/{organization,project_extensions}/` | 组织/项目级 Profile | 手写（契约） |
| `schema/` | `interface_contract` / `interface_profile` / `binding` / `compatibility` / `release_manifest` 5 个 YAML-Schema | 手写（所有权归 hwif） |
| `tests/{schema,compile,compatibility,consumer}/` | 正/负向样例与编译/兼容/消费者测试 | 依赖工具 |
| `tools/` | 6 个 T2 脚本（contract_validate/view_generate/sv_consistency_check/compatibility_check/impact_analysis/package_release） | 待收敛 |
| `generated/` | 版本化输出（views/docs/ipxact/catalog） | 幂等生成，禁手改 |
| `docs/` | architecture / compatibility-guide / modeling-guide / naming-convention | 部分可生成 |

### 2.2 skill 仓（`aixsilicon_skill_repo`）

- canonical suite：`ip-development-suite`（21 子 skill）、`doc-to-markdown`、`aixsilicon-workspace-management`；
- 均遵循"SKILL.md + 内置 scripts/ + references/"结构（[`skill_repo_plan.md`](../../repos/aixsilicon_skill_repo/skill_repo_plan.md) §5）；
- **Gap**：无 HWIF 生命周期 suite；`design-hardware-interface`（P0）在 plan 中列了未实现。

### 2.3 tool 仓（`aixsilicon_tool_repo`）

- 已有 `aix-hwif-gen` 包（validate/generate/hac-generate）；
- **按新决策**：HWIF 生命周期能力归 skill-repo；`aix-hwif-gen` 标 deprecated 并收敛（阶段 B/C）。

## 3. 边界与所有权（依 ownership-map.yaml）

| 资产 | Owner 仓 | 本规划动作 |
|---|---|---|
| `schema/` Interface Contract/Profile/Binding/Compatibility/Release | `aixsilicon_hwif_repo` | 保留 SSOT，不迁移；Schema 变更破坏性需 Major |
| `contracts/`（contract/profile/binding YAML） | `aixsilicon_hwif_repo` | 人工维护 SSOT |
| 全生命周期确定性脚本（spec→gen→check→compat→impact→package） | `aixsilicon_skill_repo` | 内置 `hwif-development-suite` 各子 skill `scripts/` |
| HWIF 方法论与编排（SKILL.md/路由/冲突边界/上下文） | `aixsilicon_skill_repo` | `hwif-development-suite` |
| `generated/`（views/docs/ipxact） | `aixsilicon_hwif_repo` | 仅 skill 幂等写入，禁止手改 |
| FuseSoC `.core`（发布态） | `aixsilicon_hwif_repo` | 由 `hwif-fusesoc-pack` 子 skill 生成，skill 不拥有 RTL 实现 |
| RTL（`rtl/*.sv`）实意 | `aixsilicon_hwif_repo` | **由 skill 生成+审，但仓库归属 hwif**；不归 skill 仓 |
| Release/Catalog 资产 | `aixsilicon_catalog_repo` | `hwif-release-package` 输入，不直写 |

> **归属原则（tools-repo vs skill-repo）**
>
> - **tools-repo（`aixsilicon_tool_repo`）只放"整块、独立、可复用"的产品级工具**（`aix-reg-tool`、`aix-schema`、`aix-address-map`、`aix-dvsim`），每个工具独立 Schema/退出码/版本。
> - **领域/方法论编排与其自带小型确定性辅助 → skill-repo 对应 skill**（`ip-development-suite` 的 `scripts/` 为既有先例）。HWIF 生成/校验/兼容/影响/打包属 HWIF 领域专用，**统一放 `hwif-development-suite` 内置 `scripts/`**，不再放 tool-repo 的 `aix-hwif-gen` 包。
> - **environment/setup**（aix 环境管理、workspace bootstrap、make/pre-commit）归 [`aixsilicon-workspace-management`](../../repos/aixsilicon_skill_repo/registry/skills.yaml:56)。
> - 判定口诀：**市场级通用产品工具 → tool-repo；领域方法/判断 + 小型确定性辅助 → skill-repo；环境准备 → workspace-management skill。**

## 4. Skill 设计（hwif-development-suite 全生命周期）

### 4.1 子 skill 与仓库结构映射

| 子 skill | 覆盖阶段 | 读写 hwif 路径 | 内置脚本 |
|---|---|---|---|
| `hwif-spec-author` | 接口规格（协议引用/需求/Design spec） | `docs/` 或 `bus/<family>/README` 关联 | —（方法为主；可用 `spec_to_contract.py` 从规格抽取契约骨架） |
| `hwif-contract-author` | Contract/Profile/Binding 编写 | `bus/<family>/contract/*.interface.yaml`、`*_base/org profile.yaml`、`bindings/<type>/*.yaml` | `contract_author_skel.py`（模板/字段检查） |
| `hwif-contract-validate` | Schema + 语义正/负样例校验（G0） | 读 `schema/`、`bus/<family>/contract/`、`tests/schema/` | `contract_validate.py` |
| `hwif-view-generate` | 多视图生成 + drift（View A/B/C/D + IP-XACT + 文档） | 写 `generated/<family>/`、`generated/docs|ipxact|catalog/` | `view_generate.py`（`--check-only`） |
| `hwif-sv-consistency` | SV package/interface 与 YAML 一致性检查 | 读 `rtl/*.sv`；比对 `generated/` | `sv_consistency_check.py` |
| `hwif-compatibility-check` | 兼容判定（DIRECT/ADAPTER_REQUIRED/INCOMPATIBLE） | 读 `compatibility.schema.yaml`、`profiles/`、契约 | `compatibility_check.py` |
| `hwif-impact-analysis` | 变更影响（谁消费、破坏面、SemVer 建议） | 读 `bindings/`、`tests/consumer/`、依赖图 | `impact_analysis.py` |
| `hwif-fusesoc-pack` | 生成/校验 `.core`（fileset/target）与发布态 | 写 `bus/<family>/aix_interface_<family>.core` | `core_gen.py` + `package_release.py`（打包） |
| `hwif-release-package` | Release 包 + Catalog 输入 + Evidence | 写 `generated/catalog/`、`release_manifest.yaml` | `package_release.py` |

> **RTL 实意、`.core`、验证数据仍是 hwif 仓资产**；skill 只编排"怎么写、调什么脚本、过哪些 Gate"，不把 RTL/依赖收进 skill 仓。

### 4.2 SKILL.md 骨架（每个子 skill 遵循）

```markdown
---
name: hwif-<sub-skill>
description: <pushy 触发描述；覆盖近邻词；明确"什么情况不要触发">
---

# <子 skill 名>

## Goal
## Preconditions（上游 Gate；缺失则停止并说明）
## Required context（读 schema/ contracts/ generated/ 最小集）
## Procedure（命令式；调用 scripts/ 对应入口，示例命令）
## Output contract（写 hwif 仓精确路径 / 文件格式 / hash）
## Verification gates（contract-valid / view-fresh / sv-consistent / compat-pass / package-ok）
## Stop / ask-human（改 Schema、删 generated、破坏性 SemVer、改 VLNV 时停）
## Failure recovery（hash 漂移 / CI 拒绝怎么定位）
## Relevant references（references/*.md 一层链接）
```

### 4.3 触发描述（Frontmatter description，pushy 版示例）

> "当用户需要编写、审查、校验 HWIF 接口规格/契约/Profile/Binding、生成接口多视图（SV package/interface/flat/IP-XACT/文档）、检查 SV 与 YAML 一致性、判定接口兼容性、分析接口变更影响、生成 FuseSoC `.core` 或打包 HWIF Release 时，务必使用此 suite。即使只提到 'APB/AXI/AXI-Lite/AXI-Stream/AHB-Lite/OBI/TileLink/UART/SPI/I2C 接口'、'接口封装'、'两个接口能否直连'、'接口改了影响谁'、'给接口做 fusesoc 打包' 也命中。内置确定性脚本统一 `uv run` 入口；禁止手工手写 SV interface/IP-XACT/`.core`。任务较小时只加载匹配子 skill。"

### 4.4 子 skill 路由 + 冲突边界（near-miss）

| 用户意图 | 子 skill | 什么时候不用 |
|---|---|---|
| "新增 APB 契约" / "加 pprot 可选信号" | `hwif-contract-author` | 写 RTL **Driver**/VIP 时不用（转 vip skill） |
| "校验这些 interface.yaml" | `hwif-contract-validate` | 不生成，只校验 |
| "生成 SV/ipxact/doc" / "重跑生成" | `hwif-view-generate` | 不改契约语义 |
| "RTL 和 YAML 对不上" | `hwif-sv-consistency` | 单纯的 RTL bug 调试不用 |
| "AXI 和 APB 能否直连" | `hwif-compatibility-check` | 实现 adapter 不用（转 cbb） |
| "接口变更影响谁" | `hwif-impact-analysis` | 只分析，不改契约 |
| "生成 .core / fileset / target" | `hwif-fusesoc-pack` | 依赖编译/仿真不用（转工作区） |
| "HWIF Release / Catalog" | `hwif-release-package` | 直写 Catalog 不用，须经流程 |

**跨套件冲突边界**：
- `hwif-contract-author` vs `ip-development-suite/03-hld-architect`：IP 内部架构含接口 → 后者；公共接口契约 → 前者。
- `hwif-view-generate` vs `aix-reg-tool`（SystemRDL）：寄存器 CSR 生成 → reg-tool；接口类型/端口视图 → 本 suite。
- `hwif-compatibility-check` vs `cbb-adapter`:前者判定，后者实现转换。
- `hwif-contract-validate` vs `doc-to-markdown`：文档转换不触发本 suite。

### 4.5 Eval 与触发测试（skill-creator 方法论）

- **端到端**（`evals/evals.json`）：每子 skill ≥2 真实 prompt + 1 负向；fixture 用现有 `bus/apb/contract/*`；断言含：契约校验通过、生成哈希稳定、`--check-only` 拒绝手改、SV 一致性通过、兼容判定正确、影响列表与依赖图一致、`.core` 结构合法、Release 输入完整。
- **触发回归**（`evals/trigger-query.json`）：20 条 should/should-not 查询覆盖 "APB"、"接口封装"、"能否直连"、"接口影响"、"fusesoc 打包" 等近邻词；`run_loop` ≤5 迭代优化 description，test 集选优防过拟合。
- **CI**：`validate.yaml`（pytest scripts）+ `eval.yaml`（eval/触发回归）；description 变更须过触发回归。

### 4.6 Registry 登记（`registry/skills.yaml` 追加）

```yaml
- id: hwif-development-suite
  version: 0.1.0
  suite: hwif-development
  maturity: experimental
  owner: hw-platform
  risk_class: P1
  reads: [aixsilicon_hwif_repo]
  writes:
    - repo: aixsilicon_hwif_repo
      paths: [bus, peripheral, foundation, dft_debug, safety_security, system, memory, common, accelerator, bindings, profiles, generated]   # 契约+结果；SV/core 由 skill 生成后经人工审
  required_tools: [hwif-development-suite/scripts]
  required_gates: [contract-valid, view-fresh, sv-consistent, compat-pass, core-valid, package-ok]
  evals: skills/hwif-development-suite/evals/evals.json
  outputs: { contract: contracts/skill-result.schema.yaml }
```

## 5. 实施顺序（4 个分片，每片可独立 PR）

| 分片 | 内容 | 入口 PR | 出口证据 |
|---|---|---|---|
| **P1 skill-gen** | skill-repo 建 `hwif-development-suite`（9 子 skill + 内置 scripts + evals + tests），从 hwif T2 迁移并保留确定性输出/退出码 | skill_repo PR | ✅ 2026-08-17 落地：9 子 skill + `scripts/hwif_tool.py` 唯一入口 + `scripts/legacy/`（6 个迁移脚本，HWIF_ROOT 适配）；pytest 8/8、ruff 全绿、真实 hwif 契约 validate smoke（57+ PASS / 3 HAC-IF profile FAIL，发现 hac_p0/p1/p2 历史缺口）；evals/trigger-query 就位 |
| **P2 contract gates** | APB/常用契约正负样例、Schema 校验、drift/SV 一致性门禁接入 CI | hwif_repo PR | ✅ 2026-08-17 落地：schema 用例扩至 7/7（含 APB 正样例 + capability/width 负样例）；semantic_check + AMBA 桥 compat 修复；CI 新增 hwif-gates job；唯一入口全门禁验证通过（62 views 无漂移/64 core/ADAPTER） |
| **P3 hwif-only** | hwif 仓 `tools/` 与 `tests/` 直接删除（用户决策），只留契约/generated/RTL/SV/core | hwif_repo PR | ✅ 2026-08-17 落地（v2 删除语义）：样例迁 skill tests/data + golden pytest（15/15）；CI 重写为自含结构/core 校验并断言 tools/tests 不存在；64 core/62 interface/18 profile 完整；skill 唯一入口 validate PASS / core 64 / generate 62 视图无漂移 |
| **P4 tool-sunset** | tool-repo `packages/aix-hwif-gen` 标记 deprecated（阶段 B/C），功能由 skill 内置脚本承接 | tool_repo PR | ✅ 2026-08-17 落地：README/pyproject deprecated + plugin 分派告警；frozen 快照 noqa；ruff/compile 全绿。阶段 C 条件：公共入口统一后删除包 |

依赖顺序：`P1 → P2 → P3`、`P4` 在 P1 稳定后执行；P2 的契约样例作为 P3/P4 验证输入。

## 6. 验收标准（与 roadmap C1～C3 对齐）

- **基础**：`hwif-development-suite` 内置脚本在 clean workspace 可用，同输入同 hash（与旧 T2 锁定一致）；
- **契约**：APB 正负样例通过；手改 `generated/`、SV 与 YAML 不一致、`.core` 非法均被拒绝；
- **生命周期**：一名 Agent 可按 spec→contract→validate→gen→consistency→compat→impact→fusesoc→release 对现有 `bus/apb` 走通一条 happy path；
- **Skill**：`SKILL.md` 触发路由正确，`evals/evals.json` 端到端断言全绿，`trigger-query.json` 触发回归无 near-miss 误触发；
- **收敛**：hwif 仓 `tools/` 与 tool-repo `aix-hwif-gen` 移除后公共 CI 仍绿色，`make check` / pre-commit 全绿。

## 7. 风险与缓解

| 风险 | 影响 | 缓解 |
|---|---|---|
| 迁移脚本到 skill 时行为漂移 | 生成 hash 变化 | P1 以 `--legacy` 互比对锁定 hash，与旧 T2 对照 |
| 触发描述与 ip-development-suite / reg-tool 冲突 | 路由错乱、误触发 | §4.4 冲突边界 + `trigger-query.json` 回归；description 变更须过回归 |
| skill 私有化后公共 CI 依赖私有内容 | 开源仓 CI 失败 | 内置脚本标准库优先、skill 仓 pytest；hwif 公共 CI 只校验结果 |
| `.core`/SV/RTL 生成与手写混治 | 众源漂移 | 差异仅由 `generated/` + `sv_consistency` + `core` gate 判定，手写区须显式声明 |
| 删除 T2/包后历史 CI 引用断裂 | 公共门禁失败 | 先建唯一入口并更新 CI 指向，再删除旧实现 |

## 8. 关联任务（按里程碑回填 todo.md）

- M2：HWIF-001（APB Contract/Profile/Binding 冻结）依赖 **P2 正负样例 + hwif-contract-* 子 skill**；
- M2：HWIF-002（三视图生成 + drift check）依赖 **P1 hwif-view-generate + hwif-sv-consistency**；
- M3：HWIF-003（VIP/IP/CBB 消费者联验）依赖 **hwif-compatibility-check + hwif-impact-analysis**；
- M3/M4：HWIF-004（发布 qualified 接口资产）依赖 **hwif-fusesoc-pack + hwif-release-package**。

## 9. 落盘与提交

- 本文件：[`docs/hwif/aix-hwif-gen-unified-plan.md`](aix-hwif-gen-unified-plan.md)（父仓，只读规划）；
- Change Bundle：[`changesets/CHG-2026-HWIF-001.yaml`](../../changesets/CHG-2026-HWIF-001.yaml)；
- 实施：先在 skill-repo 建 suite（P1），再 hwif 仓收敛（P2/P3），最后 tool-repo 收敛 `aix-hwif-gen`（P4），遵守 ADR-0006 阶段 A/B/C 迁移路径。