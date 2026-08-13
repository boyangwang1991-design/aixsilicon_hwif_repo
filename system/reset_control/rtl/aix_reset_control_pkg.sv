// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_reset_control_pkg: 复位控制 req/rsp 聚合结构（View A）。
// 信号集对齐 system/reset_control/contract/reset_control.interface.yaml（IFC-RSTC-001）。

package aix_reset_control_pkg;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic reset_req;
  } reset_control_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic       reset_ack;
    logic       reset_status;
    logic [7:0] reset_cause; // capability: cause_report（可选）
  } reset_control_rsp_t;

endpackage : aix_reset_control_pkg
