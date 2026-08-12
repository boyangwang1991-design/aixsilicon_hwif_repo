// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_lite_if: AXI4-Lite 接口（View B）。

interface aix_axi_lite_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32,
  parameter int unsigned USER_W = 1
) (
  input logic clk,
  input logic rst_n
);

  // AW
  logic                    aw_valid;
  logic                    aw_ready;
  logic [ADDR_W-1:0]       aw_addr;
  logic [2:0]              aw_prot;
  logic [USER_W-1:0]       aw_user;
  // W
  logic                    w_valid;
  logic                    w_ready;
  logic [DATA_W-1:0]       w_data;
  logic [DATA_W/8-1:0]     w_strb;
  logic [USER_W-1:0]       w_user;
  // B
  logic                    b_valid;
  logic                    b_ready;
  logic [1:0]              b_resp;
  logic [USER_W-1:0]       b_user;
  // AR
  logic                    ar_valid;
  logic                    ar_ready;
  logic [ADDR_W-1:0]       ar_addr;
  logic [2:0]              ar_prot;
  logic [USER_W-1:0]       ar_user;
  // R
  logic                    r_valid;
  logic                    r_ready;
  logic [DATA_W-1:0]       r_data;
  logic [1:0]              r_resp;
  logic [USER_W-1:0]       r_user;

  modport initiator (
    output aw_valid, aw_addr, aw_prot, aw_user,
           w_valid, w_data, w_strb, w_user,
           b_ready, ar_valid, ar_addr, ar_prot, ar_user,
           r_ready,
    input  aw_ready, w_ready, b_valid, b_resp, b_user,
           ar_ready, r_valid, r_data, r_resp, r_user
  );
  modport target (
    input  aw_valid, aw_addr, aw_prot, aw_user,
           w_valid, w_data, w_strb, w_user,
           b_ready, ar_valid, ar_addr, ar_prot, ar_user,
           r_ready,
    output aw_ready, w_ready, b_valid, b_resp, b_user,
           ar_ready, r_valid, r_data, r_resp, r_user
  );

endinterface : aix_axi_lite_if
