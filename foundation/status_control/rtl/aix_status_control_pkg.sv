// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_status_control_pkg: 状态/控制 req/rsp 聚合结构（View A）。
// 信号集对齐 foundation/status_control/contract/status_control.interface.yaml（IFC-STATUS-001）。

package aix_status_control_pkg;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic enable;
  } status_control_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic busy;
    logic done;
    logic idle;
    logic error; // capability: error_report（可选）
  } status_control_rsp_t;

endpackage : aix_status_control_pkg
