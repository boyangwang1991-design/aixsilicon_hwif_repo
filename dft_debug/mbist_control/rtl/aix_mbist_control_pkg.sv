// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_mbist_control_pkg: MBIST 控制 req/rsp 聚合结构（View A）。
// 信号集对齐 dft_debug/mbist_control/contract/mbist_control.interface.yaml（IFC-MBIST-001）。

package aix_mbist_control_pkg;

  localparam int unsigned MBIST_ADDR_W = 32;

  // 控制（controller -> endpoint）
  typedef struct packed {
    logic start;
  } mbist_control_req_t;

  // 状态/结果（endpoint -> controller）
  typedef struct packed {
    logic                   done;
    logic                   fail;
    logic [MBIST_ADDR_W-1:0] fail_addr; // capability: addr_report（可选）
    logic [7:0]              syndrome;  // capability: syndrome_report（可选）
  } mbist_control_rsp_t;

endpackage : aix_mbist_control_pkg
