// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_lifecycle_state_pkg: 安全生命周期状态 req/rsp 聚合结构（View A）。
// 信号集对齐 system/lifecycle_state/contract/lifecycle_state.interface.yaml（IFC-LS-001）。

package aix_lifecycle_state_pkg;

  localparam int unsigned LC_STATE_W = 8;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic [LC_STATE_W-1:0] lc_state_req;
  } lifecycle_state_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic                   lc_state_ack;
    logic [LC_STATE_W-1:0]  lc_state;
    logic                   lc_state_valid;
  } lifecycle_state_rsp_t;

endpackage : aix_lifecycle_state_pkg
