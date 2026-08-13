# generated/docs

由 `tools/view_generate/view_generate.py --docs` 生成的接口文档（Interface Spec，markdown）。

- 每个接口族一份 `<name>_spec.md`；
- 派生文件禁止手工修改，改契约后重新生成；
- 生成视图由 `.gitignore` 忽略，不在 git 中跟踪（CI/红区工具决定是否提交，plan §8）。
