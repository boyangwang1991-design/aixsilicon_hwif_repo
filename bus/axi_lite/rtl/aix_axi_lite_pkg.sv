// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_lite_pkg: AXI4-Lite req/rsp 聚合结构（View A）。
// 参考 PULP AXI 的 req/rsp 聚合方式（ax_lite_aw_t / ax_lite_ar_t 等）。

package aix_axi_lite_pkg;

  import aix_common_pkg::*;

  localparam int unsigned AXIL_ADDR_W = 32;
  localparam int unsigned AXIL_DATA_W = 32;
  localparam int unsigned AXIL_USER_W = 1;

  // Write address channel
  typedef struct packed {
    logic [AXIL_ADDR_W-1:0] addr;
    logic [2:0]             prot;
    logic [AXIL_USER_W-1:0] user;
  } ax_lite_aw_t;

  // Write data channel
  typedef struct packed {
    logic [AXIL_DATA_W-1:0]  data;
    logic [AXIL_DATA_W/8-1:0] strb;
    logic [AXIL_USER_W-1:0]  user;
  } ax_lite_w_t;

  // Write response channel
  typedef struct packed {
    logic [1:0]             resp;
    logic [AXIL_USER_W-1:0] user;
  } ax_lite_b_t;

  // Read address channel
  typedef struct packed {
    logic [AXIL_ADDR_W-1:0] addr;
    logic [2:0]             prot;
    logic [AXIL_USER_W-1:0] user;
  } ax_lite_ar_t;

  // Read data channel
  typedef struct packed {
    logic [AXIL_DATA_W-1:0]  data;
    logic [1:0]              resp;
    logic [AXIL_USER_W-1:0]  user;
  } ax_lite_r_t;

  // Request / response 聚合（valid/ready 信号单独）
  typedef struct packed {
    ax_lite_aw_t aw;
    ax_lite_w_t  w;
    logic        aw_valid;
    logic        aw_ready;
    logic        w_valid;
    logic        w_ready;
    logic        b_valid;
    logic        b_ready;
    ax_lite_b_t  b;
  } axi_lite_req_t;

  typedef struct packed {
    ax_lite_ar_t ar;
    logic        ar_valid;
    logic        ar_ready;
    logic        r_valid;
    logic        r_ready;
    ax_lite_r_t  r;
  } axi_lite_rsp_t;

  // 响应编码
  localparam logic [1:0] AXI_RESP_OKAY   = 2'b00;
  localparam logic [1:0] AXI_RESP_SLVERR = 2'b10;
  localparam logic [1:0] AXI_RESP_DECERR = 2'b11;

endpackage : aix_axi_lite_pkg
