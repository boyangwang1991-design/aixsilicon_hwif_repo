// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_pkg: AXI4 req/rsp 聚合结构（View A）。
// 参考 PULP AXI 的 typedef/assign 与 req/rsp 聚合模式（见 plan 第 21.1 节）。
// 与 contract/axi.interface.yaml 保持一致（由 sv_consistency_check 校验）。

package aix_axi_pkg;

  import aix_common_pkg::*;

  localparam int unsigned AXI_ID_W    = 8;
  localparam int unsigned AXI_ADDR_W  = 64;
  localparam int unsigned AXI_DATA_W  = 64;
  localparam int unsigned AXI_USER_W  = 1;
  localparam int unsigned AXI_STRB_W  = AXI_DATA_W/8;

  // 通道类型（PULP AXI 风格，协议标准简称）
  typedef struct packed {
    logic [AXI_ID_W-1:0]    id;
    logic [AXI_ADDR_W-1:0]  addr;
    logic [7:0]             len;
    logic [2:0]             size;
    logic [1:0]             burst;
    logic                   lock;
    logic [3:0]             cache;
    logic [2:0]             prot;
    logic [3:0]             qos;
    logic [3:0]             region;
    logic [5:0]             atop;   // capability: atop
    logic [AXI_USER_W-1:0]  user;   // capability: user_sideband
  } axi_aw_chan_t;

  typedef struct packed {
    logic [AXI_DATA_W-1:0]  data;
    logic [AXI_STRB_W-1:0]  strb;
    logic                   last;
    logic [AXI_USER_W-1:0]  user;
  } axi_w_chan_t;

  typedef struct packed {
    logic [AXI_ID_W-1:0]    id;
    logic [1:0]             resp;
    logic [AXI_USER_W-1:0]  user;
  } axi_b_chan_t;

  typedef struct packed {
    logic [AXI_ID_W-1:0]    id;
    logic [AXI_ADDR_W-1:0]  addr;
    logic [7:0]             len;
    logic [2:0]             size;
    logic [1:0]             burst;
    logic                   lock;
    logic [3:0]             cache;
    logic [2:0]             prot;
    logic [3:0]             qos;
    logic [3:0]             region;
    logic [AXI_USER_W-1:0]  user;
  } axi_ar_chan_t;

  typedef struct packed {
    logic [AXI_ID_W-1:0]    id;
    logic [AXI_DATA_W-1:0]  data;
    logic [1:0]             resp;
    logic                   last;
    logic [AXI_USER_W-1:0]  user;
  } axi_r_chan_t;

  // Request / Response 聚合（写通道 + 读通道）
  typedef struct packed {
    axi_aw_chan_t aw;
    logic         aw_valid;
    logic         aw_ready;
    axi_w_chan_t  w;
    logic         w_valid;
    logic         w_ready;
    axi_b_chan_t  b;
    logic         b_valid;
    logic         b_ready;
  } axi_req_t;

  typedef struct packed {
    axi_ar_chan_t ar;
    logic         ar_valid;
    logic         ar_ready;
    axi_r_chan_t  r;
    logic         r_valid;
    logic         r_ready;
  } axi_rsp_t;

  // 响应编码
  localparam logic [1:0] AXI_RESP_OKAY   = 2'b00;
  localparam logic [1:0] AXI_RESP_EXOKAY = 2'b01;
  localparam logic [1:0] AXI_RESP_SLVERR = 2'b10;
  localparam logic [1:0] AXI_RESP_DECERR = 2'b11;

  // Burst 编码
  localparam logic [1:0] AXI_BURST_FIXED = 2'b00;
  localparam logic [1:0] AXI_BURST_INCR  = 2'b01;
  localparam logic [1:0] AXI_BURST_WRAP  = 2'b10;

endpackage : aix_axi_pkg
