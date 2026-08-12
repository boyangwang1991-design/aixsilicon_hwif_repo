# tests/compatibility

Compatibility rule 单元测试。结论只能是 DIRECT / ADAPTER_REQUIRED / INCOMPATIBLE。

典型用例（对应 plan 第 13.3 节）：

- 协议与 Profile 一致、参数一致 → DIRECT；
- AXI 数据位宽不同 → ADAPTER_REQUIRED；
- Source 要求 ATOP，Target 不支持 → INCOMPATIBLE；
- Stream 有 TLAST，Sink 不理解 packet boundary → INCOMPATIBLE（除非显式 strip adapter）；
- Safety event severity 语义不一致 → INCOMPATIBLE。
