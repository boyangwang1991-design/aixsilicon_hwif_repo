// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_apb3_pkg: APB3 端点 req/rsp 结构（View A）。
// 参考 PULP AXI 的 req/rsp 聚合方式（APB 为单通道，直接聚合读写）。

package aix_apb3_pkg;

  import aix_common_pkg::*;

  localparam int unsigned APB_ADDR_W = 32;
  localparam int unsigned APB_DATA_W = 32;

  // APB3 请求（initiator -> target）
  typedef struct packed {
    logic                   psel;
    logic                   penable;
    logic [APB_ADDR_W-1:0]  paddr;
    logic                   pwrite;
    logic [APB_DATA_W-1:0]  pwdata;
  } apb3_req_t;

  // APB3 响应（target -> initiator）
  typedef struct packed {
    logic                   pready;
    logic [APB_DATA_W-1:0]  prdata;
    logic                   pslverr;
  } apb3_rsp_t;

endpackage : aix_apb3_pkg