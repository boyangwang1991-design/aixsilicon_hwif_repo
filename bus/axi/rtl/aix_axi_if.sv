// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_if: AXI4 接口（View B）。
// 供 VIP / TB / 局部集成使用，提供 initiator/target modport。

interface aix_axi_if #(
  parameter int unsigned ID_W   = 8,
  parameter int unsigned ADDR_W = 64,
  parameter int unsigned DATA_W = 64,
  parameter int unsigned USER_W = 1
) (
  input logic clk,
  input logic rst_n
);

  // AW
  logic                  aw_valid;
  logic                  aw_ready;
  logic [ID_W-1:0]       aw_id;
  logic [ADDR_W-1:0]     aw_addr;
  logic [7:0]            aw_len;
  logic [2:0]            aw_size;
  logic [1:0]            aw_burst;
  logic                  aw_lock;
  logic [3:0]            aw_cache;
  logic [2:0]            aw_prot;
  logic [3:0]            aw_qos;
  logic [3:0]            aw_region;
  logic [5:0]            aw_atop;
  logic [USER_W-1:0]     aw_user;
  // W
  logic                  w_valid;
  logic                  w_ready;
  logic [DATA_W-1:0]     w_data;
  logic [DATA_W/8-1:0]   w_strb;
  logic                  w_last;
  logic [USER_W-1:0]     w_user;
  // B
  logic                  b_valid;
  logic                  b_ready;
  logic [ID_W-1:0]       b_id;
  logic [1:0]            b_resp;
  logic [USER_W-1:0]     b_user;
  // AR
  logic                  ar_valid;
  logic                  ar_ready;
  logic [ID_W-1:0]       ar_id;
  logic [ADDR_W-1:0]     ar_addr;
  logic [7:0]            ar_len;
  logic [2:0]            ar_size;
  logic [1:0]            ar_burst;
  logic                  ar_lock;
  logic [3:0]            ar_cache;
  logic [2:0]            ar_prot;
  logic [3:0]            ar_qos;
  logic [3:0]            ar_region;
  logic [USER_W-1:0]     ar_user;
  // R
  logic                  r_valid;
  logic                  r_ready;
  logic [ID_W-1:0]       r_id;
  logic [DATA_W-1:0]     r_data;
  logic [1:0]            r_resp;
  logic                  r_last;
  logic [USER_W-1:0]     r_user;

  modport initiator (
    output aw_valid, aw_id, aw_addr, aw_len, aw_size, aw_burst,
           aw_lock, aw_cache, aw_prot, aw_qos, aw_region, aw_atop, aw_user,
           w_valid, w_data, w_strb, w_last, w_user,
           b_ready,
           ar_valid, ar_id, ar_addr, ar_len, ar_size, ar_burst,
           ar_lock, ar_cache, ar_prot, ar_qos, ar_region, ar_user,
           r_ready,
    input  aw_ready, w_ready,
           b_valid, b_id, b_resp, b_user,
           ar_ready,
           r_valid, r_id, r_data, r_resp, r_last, r_user
  );
  modport target (
    input  aw_valid, aw_id, aw_addr, aw_len, aw_size, aw_burst,
           aw_lock, aw_cache, aw_prot, aw_qos, aw_region, aw_atop, aw_user,
           w_valid, w_data, w_strb, w_last, w_user,
           b_ready,
           ar_valid, ar_id, ar_addr, ar_len, ar_size, ar_burst,
           ar_lock, ar_cache, ar_prot, ar_qos, ar_region, ar_user,
           r_ready,
    output aw_ready, w_ready,
           b_valid, b_id, b_resp, b_user,
           ar_ready,
           r_valid, r_id, r_data, r_resp, r_last, r_user
  );

endinterface : aix_axi_if
