# view_generate — 派生视图生成器

从 YAML Contract 确定性生成派生视图。

## 生成内容

- SV interface / modport（View B）；
- Flat Port Wrapper（View C，`<prefix>_<chan>_<sig>_<dir>` 命名）；
- IP-XACT busDefinition / abstractionDefinition；
- Interface 文档（spec / integration / migration guide）；
- type fingerprint 与 manifest 片段。

## 原则

- 确定性：同输入必须产生相同 hash；
- 生成物进入 `generated/`，禁止手工修改；
- 发布态 Core 由流水线生成，禁止手工维护。

## 状态

- 待建设。
