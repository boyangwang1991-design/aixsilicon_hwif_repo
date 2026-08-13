# generated/ipxact

由 `tools/view_generate/view_generate.py --ipxact` 生成的 IP-XACT busDefinition / abstractionDefinition（可选交换视图）。

- 每个接口族一份 `<name>_busdef.xml` 与 `<name>_absdef.xml`；
- 派生文件禁止手工修改，改契约后重新生成；
- 生成视图由 `.gitignore` 忽略，不在 git 中跟踪（CI/红区工具决定是否提交，plan §8）。
