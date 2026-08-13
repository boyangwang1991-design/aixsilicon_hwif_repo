# generated — 派生生成物

本目录存放由工具从 YAML 契约确定性生成的派生视图（SV interface、IP-XACT、文档、catalog 等）。

- **SV interface 视图**：由 `tools/view_generate/view_generate.py` 生成，进入 `generated/<family>/`；
- 派生文件**禁止手工修改**，改动须改契约后重新生成；
- 是否将生成文件提交 Git 由 CI/红区工具可用性决定（plan §8）：当前生成视图默认忽略（`gitignore` 中 `generated/**/aix_*_if.sv`），以保证与手工 `rtl/` 不冲突；正式 Release 包必须包含生成结果。
