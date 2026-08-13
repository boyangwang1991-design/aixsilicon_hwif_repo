# tests/compile

SV package/interface 多工具编译基线。

- 至少选择组织实际使用的两种商业工具（VCS / Xcelium / Questa）完成 Qualified；
- 选择性检查 Verilator 用于基础 package/struct 兼容；
- 不能因开源工具对完整 SystemVerilog interface 支持有限而降低正式接口语义。

## 运行

```bash
# 自动选择本机可用工具（优先 vlogan/VCS，其次 iverilog）按拓扑顺序编译全部 RTL
python3 tests/compile/run_compile_tests.py
```

- 退出码 `0`：编译通过（或环境无工具时 SKIP）。
