# Contributing to AIXSILICON HW Interface Repository

## 1. 本仓库的边界

请先阅读 [`plan.md`](plan.md:1) 第 3 节「仓库边界」。提交内容必须属于接口契约范畴：

- 描述「有哪些信号、角色、语义、约束」→ 本仓库；
- 描述「如何驱动、监测、检查」→ VIP Repo；
- 描述「如何转换、缓存、同步、桥接」→ CBB Repo；
- 描述「哪个实例连接哪个实例」→ SoC Integration；
- 描述「寄存器地址和字段」→ SystemRDL；
- 描述「工艺 Macro 如何实现」→ Techlib。

## 2. 开发流程

1. 从受保护的 `main` 分支创建特性分支；
2. 遵循「YAML SSOT → 派生视图 → 一致性检查 → 测试」的顺序修改；
3. 任何对信号名、宽度、方向、必选/可选、参数默认值、tie-off、capability、compatibility 的修改都**必须先改 YAML Contract**，再同步 SV / 文档 / 绑定；
4. 运行 PR CI 全部门禁（见 [`plan.md`](plan.md:1043) 第 18.1 节）；
5. 通过架构/协议评审后合入。

## 3. 新增一个接口族

参考标准模板 [`bus/axi/`](bus/axi/README.md:1) 或最小模板 [`foundation/ready_valid/`](foundation/ready_valid/README.md:1)：

```text
<family>/
├── README.md
├── CHANGELOG.md
├── contract/           # *.interface.yaml / *.profile.yaml / compatibility.yaml
├── rtl/                # *_pkg.sv / *_typedef.svh / *_assign.svh / *_if.sv / *_flat_wrapper.sv
├── binding/            # vip_binding.yaml / ipxact_mapping.yaml
├── docs/               # interface_spec.md / profile_guide.md / integration_guide.md / migration_guide.md
├── tests/              # compile / type_roundtrip / flat_roundtrip / compatibility
├── examples/
├── metadata/           # release_manifest.yaml / provenance.yaml
└── aix_interface_<name>.core
```

## 4. ID、VLNV 与版本

- 稳定 ID：`IFC-<FAMILY>-<NNN>`，例如 `IFC-STREAM-001`；
- VLNV：`aix:interface:<name>:<major>.<minor>.<patch>`；
- SemVer 规则见 [`plan.md`](plan.md:952) 第 16.1 节；packed struct 字段增删视为破坏性变更。

## 5. 成熟度状态

| 状态 | 含义 | 使用限制 |
|---|---|---|
| `draft` | 讨论中 | 禁止项目依赖 |
| `reviewed` | 评审完成 | 允许 PoC |
| `qualified` | 测试通过 | 允许正式项目 |
| `proven` | 两个真实项目验证 | Catalog 推荐 |
| `deprecated` | 有替代 | 禁止新项目 |

## 6. 开源合规

- 引入任何第三方代码前，先在 `LICENSES/` 放置对应许可证文本并更新 `NOTICE`；
- PULP 系列项目（Solderpad / Apache-2.0）需**逐文件**审查许可证；
- 商业协议规范正文不得复制进仓库，只记录受控引用。

## 7. 代码风格

- SV 命名规范见 [`docs/naming-convention/README.md`](docs/naming-convention/README.md:1)；
- YAML Contract 必须通过 Schema 校验（见 `schema/`）；
- 禁止手工修改 `generated/` 下任何派生文件。

## 8. Review Checklist

- [ ] YAML 是唯一事实源，SV/文档/绑定已同步或由 CI 生成；
- [ ] 稳定 ID / VLNV / SemVer / Owner / lifecycle 完整；
- [ ] clock / reset / power / CDC 属性显式声明，未靠端口名猜测；
- [ ] 必选信号与可选 Capability 分离；
- [ ] 兼容性声明可自动判定（DIRECT / ADAPTER_REQUIRED / INCOMPATIBLE）；
- [ ] 提供对应的 compile / roundtrip / compatibility 测试；
- [ ] 许可证与 NOTICE 已更新。
