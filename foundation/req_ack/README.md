# req_ack — 请求/应答事件接口（L0）

描述 request/acknowledge 事件握手。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/req_ack.interface.yaml`](contract/req_ack.interface.yaml:1) |
| SV Package | [`rtl/aix_req_ack_pkg.sv`](rtl/aix_req_ack_pkg.sv:1) |
| SV Interface | [`rtl/aix_req_ack_if.sv`](rtl/aix_req_ack_if.sv:1) |
| FuseSoC Core | [`aix_interface_req_ack.core`](aix_interface_req_ack.core:1) |

## 语义要点

- 角色：`initiator`（发起）/ `target`（应答）；
- req 拉高直至 ack 到达；ack 后 req 必须释放；事件完成后 ack 释放；
- 用于事件型握手（非连续流），区别于 ready_valid 的连续背压。
