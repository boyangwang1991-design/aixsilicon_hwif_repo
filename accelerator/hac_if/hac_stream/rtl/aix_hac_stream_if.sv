// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_stream_if: HAC-STREAM 流式数据接口（View B）。

interface aix_hac_stream_if #(
  parameter int unsigned DATA_W = 128,
  parameter int unsigned ID_W   = 4,
  parameter int unsigned USER_W = 8,
  parameter logic         EN_KEEP = 1'b1,
  parameter logic         EN_LAST = 1'b1,
  parameter logic         EN_ID   = 1'b0,
  parameter logic         EN_USER = 1'b0
) (
  input logic clk,
  input logic rst_n
);

  logic                valid;
  logic                ready;
  logic [DATA_W-1:0]   data;
  logic [DATA_W/8-1:0] keep;
  logic                last;
  logic [ID_W-1:0]     id;
  logic [USER_W-1:0]   user;

  // 可选信号 tie-off
  assign keep = '0;
  assign last = 1'b0;
  assign id   = '0;
  assign user = '0;

  modport producer (output valid, data, keep, last, id, user,
                    input  ready);

  modport consumer (input  valid, data, keep, last, id, user,
                    output ready);

  modport monitor  (input  valid, ready, data, keep, last, id, user);

endinterface : aix_hac_stream_if
