# safety_security — 功能安全与安全扩展接口（L6）

| 子接口族 | 内容 | 优先级 | 状态 |
|---|---|---|---|
| [`safety_event`](safety_event/README.md:1) | fault ID、severity、domain、timestamp、ack | P0 | 完整 |
| [`fault_injection_control`](fault_injection_control/README.md:1) | inject enable/type/target/trigger/status | P1 | 骨架 |
| `integrity_sideband` | parity/ECC/CRC、poison、validity | P1 | 待建设 |
| `lockstep_compare` | compare enable、mismatch、syndrome、channel | P1 | 待建设 |
| `watchdog_service` | service/challenge/response/status | P1 | 待建设 |
| `domain_health` | alive、degraded、failed、recovery 状态 | P1 | 待建设 |
| `security_violation` | source、class、fatality、evidence 摘要 | P2 | 待建设 |

这些接口与 SafeSight、FUSA Skill Suite、PIC 和 SoCGen 保持 ID 一致；安全机制本体不在接口仓实现。
