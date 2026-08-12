// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_apb_pkg: APB 端点 req/rsp 结构（View A）。
// 参考 PULP AXI 的 req/rsp 聚合方式（APB 为单通道，直接聚合读写）。

package aix_apb_pkg;

  import aix_common_pkg::*;

  localparam int unsigned APB_ADDR_W = 32;
  localparam int unsigned APB_DATA_W = 32;

  // APB 请求（initiator -> target）
  typedef struct packed {
    logic                   psel;
    logic                   penable;
    logic [APB_ADDR_W-1:0]  paddr;
    logic                   pwrite;
    logic [APB_DATA_W-1:0]  pwdata;
    logic [APB_DATA_W/8-1:0] pstrb;  // capability: write_strobe
    logic [2:0]             pprot;   // capability: protection
  } apb_req_t;

  // APB 响应（target -> initiator）
  typedef struct packed {
    logic                   pready;
    logic [APB_DATA_W-1:0]  prdata;
    logic                   pslverr;
  } apb_rsp_t;

endpackage : aix_apb_pkg
