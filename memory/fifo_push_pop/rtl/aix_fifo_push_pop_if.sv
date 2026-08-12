// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_fifo_push_pop_if: FIFO 推/弹接口（View B）。

interface aix_fifo_push_pop_if #(
  parameter int unsigned DATA_W = 32,
  parameter int unsigned DEPTH_LOG2 = 4
) (
  input logic clk,
  input logic rst_n
);

  logic                      push_valid;
  logic                      push_ready;
  logic [DATA_W-1:0]         push_data;
  logic                      pop_valid;
  logic                      pop_ready;
  logic [DATA_W-1:0]         pop_data;
  logic                      full;
  logic                      empty;
  logic [DEPTH_LOG2:0]       level;

  modport producer (
    output push_valid, push_data,
    input  push_ready,
    input  full, empty, level
  );
  modport consumer (
    output pop_valid,
    input  pop_ready, pop_data,
    output full, empty, level
  );

endinterface : aix_fifo_push_pop_if
