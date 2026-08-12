# error_report — 错误上报接口（L1）

覆盖 recoverable/fatal、source ID、syndrome、valid/ack 的错误上报语义。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/error_report.interface.yaml`](contract/error_report.interface.yaml:1) |
| SV Package | [`rtl/aix_error_report_pkg.sv`](rtl/aix_error_report_pkg.sv:1) |
| SV Interface | [`rtl/aix_error_report_if.sv`](rtl/aix_error_report_if.sv:1) |
| FuseSoC Core | [`aix_interface_error_report.core`](aix_interface_error_report.core:1) |

## 语义要点

- 角色：`source` / `receiver`；
- 严重度：`recoverable` / `fatal`；
- 载荷：`syndrome`、`source_id`；
- valid/ack 握手用于错误上报传输；
- 安全语义事件见 [`safety_security/`](../../safety_security/README.md:1) 的 `safety_event`。
