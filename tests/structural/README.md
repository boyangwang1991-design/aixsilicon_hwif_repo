# tests/structural

结构一致性测试。

- struct pack/unpack roundtrip；
- flat wrapper roundtrip（struct↔interface↔flat 无信息丢失）；
- modport 方向检查；
- width expression 求值；
- tie-off/default 生成检查。

## 运行

```bash
python3 tests/structural/run_structural_tests.py
```

当前覆盖：width expression 求值、SV↔契约信号一致性（复用 sv_consistency_check）、flat wrapper 命名规则。
