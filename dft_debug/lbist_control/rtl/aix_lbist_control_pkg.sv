// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_lbist_control_pkg: 逻辑 BIST 控制 req/rsp 聚合结构（View A）。
// 信号集对齐 dft_debug/lbist_control/contract/lbist_control.interface.yaml（IFC-LBIST-001）。

package aix_lbist_control_pkg;

  localparam int unsigned LBIST_SIGNATURE_W = 32;

  // 控制（controller -> endpoint）
  typedef struct packed {
    logic start;
  } lbist_control_req_t;

  // 结果（endpoint -> controller）
  typedef struct packed {
    logic                        done;
    logic                        pass;
    logic                        fail;
    logic [LBIST_SIGNATURE_W-1:0] signature;
  } lbist_control_rsp_t;

endpackage : aix_lbist_control_pkg
