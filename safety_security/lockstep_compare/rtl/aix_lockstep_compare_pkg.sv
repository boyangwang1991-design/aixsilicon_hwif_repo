// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_lockstep_compare_pkg: 锁步比较 req/rsp 聚合结构（View A）。
// 信号集对齐 safety_security/lockstep_compare/contract/lockstep_compare.interface.yaml（IFC-LSC-001）。

package aix_lockstep_compare_pkg;

  localparam int unsigned LSC_CHANNEL_W = 8;
  localparam int unsigned LSC_SYNDROME_W = 32;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic compare_en;
  } lockstep_compare_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic                        mismatch;
    logic [LSC_SYNDROME_W-1:0]   mismatch_syndrome;
    logic [LSC_CHANNEL_W-1:0]    mismatch_channel;
  } lockstep_compare_rsp_t;

endpackage : aix_lockstep_compare_pkg
