// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_ahb_lite_pkg: AMBA AHB-Lite req/rsp 聚合结构（View A）。
// 信号集对齐 bus/ahb_lite/contract/ahb_lite.interface.yaml（IFC-AHB-001）。
// AHB-Lite 为地址相位与数据相位重叠的流水式握手（semantics: pipelined）。

package aix_ahb_lite_pkg;

  localparam int unsigned AHBL_ADDR_W = 32;
  localparam int unsigned AHBL_DATA_W = 32;

  // AHB-Lite transfer 编码（HTRANS）
  localparam logic [1:0] AHB_TRANS_IDLE  = 2'b00;
  localparam logic [1:0] AHB_TRANS_BUSY  = 2'b01;
  localparam logic [1:0] AHB_TRANS_NONSEQ = 2'b10;
  localparam logic [1:0] AHB_TRANS_SEQ   = 2'b11;

  // 地址相位（initiator -> target）
  typedef struct packed {
    logic [AHBL_ADDR_W-1:0] haddr;
    logic                   hwrite;
    logic [1:0]             htrans;
    logic [2:0]             hsize;
    logic [2:0]             hburst;
    logic [3:0]             hprot;
  } ahb_lite_a_t;

  // 写数据（initiator -> target）
  typedef struct packed {
    logic [AHBL_DATA_W-1:0] hwdata;
  } ahb_lite_w_t;

  // 响应（target -> initiator）
  typedef struct packed {
    logic [AHBL_DATA_W-1:0] hrdata;
    logic                   hresp;
    logic                   hready;
    logic                   hready_in;
  } ahb_lite_r_t;

  // Request / response 聚合
  typedef struct packed {
    ahb_lite_a_t a;
    ahb_lite_w_t w;
  } ahb_lite_req_t;

  typedef struct packed {
    ahb_lite_r_t r;
  } ahb_lite_rsp_t;

endpackage : aix_ahb_lite_pkg
