// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_noc_flit_pkg: NoC flit req/rsp 聚合结构（View A）。
// 信号集对齐 link/noc_flit/contract/noc_flit.interface.yaml（IFC-NOC-001）。
// flit_type 编码：0=header, 1=body, 2=tail。

package aix_noc_flit_pkg;

  localparam int unsigned NOC_FLIT_W = 128;
  localparam int unsigned NOC_VC_W   = 2;

  localparam logic [1:0] NOC_FLIT_HEADER = 2'b00;
  localparam logic [1:0] NOC_FLIT_BODY   = 2'b01;
  localparam logic [1:0] NOC_FLIT_TAIL   = 2'b10;

  // flit 通道（source -> sink，ready/valid 独立）
  typedef struct packed {
    logic [NOC_FLIT_W-1:0] flit_data;
    logic [1:0]            flit_type;
    logic [NOC_VC_W-1:0]   flit_vc;
    logic [7:0]            flit_route; // capability: routing（可选）
    logic                  flit_error; // capability: error_sideband（可选）
    logic                  flit_poison; // capability: poison（可选）
    logic                  valid;
    logic                  ready;
  } noc_flit_t;

endpackage : aix_noc_flit_pkg
