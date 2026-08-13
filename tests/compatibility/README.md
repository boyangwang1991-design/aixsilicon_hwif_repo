# tests/compatibility

Compatibility rule 单元测试。结论只能是 DIRECT / ADAPTER_REQUIRED / INCOMPATIBLE。

典型用例（对应 plan §13.3，运行 `run_compat_tests.py`）：

- AXI 位宽一致 → DIRECT；
- AXI 数据位宽不同（128 vs 32）→ ADAPTER_REQUIRED；
- AXI 与 APB 协议族不同 → INCOMPATIBLE。

## 运行

```bash
python3 tests/compatibility/run_compat_tests.py
```

> 说明：判定器为骨架级。真正接入 SoCGen 时，ADAPTER_REQUIRED 只能引用 Catalog
> 中已认证的 CBB Adapter，INCOMPATIBLE 必须显式失败（plan §13、§15.3）。
