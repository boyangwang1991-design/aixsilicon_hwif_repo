# dft_debug — 调试、测试、可观测性接口（L5）

| 子接口族 | 内容 | 优先级 | 状态 |
|---|---|---|---|
| [`trace_stream`](trace_stream/README.md:1) | timestamp、source、event、payload、overflow | P1 | 骨架 |
| [`mbist_control`](mbist_control/README.md:1) | start/done/fail/address/syndrome | P1 | 骨架 |
| `performance_event` | event ID、count/level/pulse、domain | P1 | 待建设 |
| `debug_request` | halt/resume/step/status 抽象 | P2 | 待建设 |
| `scan_control` | scan enable、test mode、scan clock/reset 抽象 | P2 | 待建设 |
| `lbist_control` | start/done/signature/pass/fail | P2 | 待建设 |
| `dfx_override` | clock/reset/isolation override 及安全限定 | P2 | 待建设 |
