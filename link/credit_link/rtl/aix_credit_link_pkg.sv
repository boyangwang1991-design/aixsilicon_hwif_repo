// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_credit_link_pkg: 信用链路接口类型。

package aix_credit_link_pkg;

  localparam int unsigned CL_FLIT_W   = 128;
  localparam int unsigned CL_VC_W     = 2;
  localparam int unsigned CL_CREDIT_W = 4;

  // flit 请求（initiator -> target）
  typedef struct packed {
    logic                   valid;
    logic [CL_FLIT_W-1:0]   data;
    logic [CL_VC_W-1:0]     vc;      // capability: vc
    logic [3:0]             qos;     // capability: qos
    logic                   retry;   // capability: retry
  } credit_link_flit_t;

  // credit 返回（target -> initiator）
  typedef struct packed {
    logic                  valid;
    logic [CL_CREDIT_W-1:0] return_count;
  } credit_return_t;

endpackage : aix_credit_link_pkg
