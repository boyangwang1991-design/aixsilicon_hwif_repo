// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_alert_pkg: 安全敏感事件 alert req/rsp 聚合结构（View A）。
// 信号集对齐 system/alert/contract/alert.interface.yaml（IFC-ALERT-001）。

package aix_alert_pkg;

  localparam int unsigned ALERT_W = 1;

  // alert 请求（source -> receiver）
  typedef struct packed {
    logic [ALERT_W-1:0] alert_valid;
    logic [ALERT_W-1:0] alert_ack;
  } alert_req_t;

  // alert 响应（receiver -> source；含可选 heartbeat）
  typedef struct packed {
    logic [ALERT_W-1:0] alert_ping;         // capability: heartbeat
    logic [ALERT_W-1:0] alert_heartbeat_ok; // capability: heartbeat
  } alert_rsp_t;

endpackage : aix_alert_pkg
