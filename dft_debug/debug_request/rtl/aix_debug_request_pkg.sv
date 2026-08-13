// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_debug_request_pkg: 调试请求 req/rsp 聚合结构（View A）。
// 信号集对齐 dft_debug/debug_request/contract/debug_request.interface.yaml（IFC-DBG-001）。

package aix_debug_request_pkg;

  // 状态编码
  localparam logic [1:0] DBG_STATUS_RUN     = 2'd0;
  localparam logic [1:0] DBG_STATUS_HALTED  = 2'd1;
  localparam logic [1:0] DBG_STATUS_STEPPING = 2'd2;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic halt_req;
    logic resume_req;
    logic step_req;
  } debug_request_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic [1:0] debug_status;
  } debug_status_t;

endpackage : aix_debug_request_pkg
