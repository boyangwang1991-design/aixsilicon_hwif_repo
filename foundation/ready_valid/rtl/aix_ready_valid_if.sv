// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_ready_valid_if: ready/valid 流接口（View B）。
// 供 VIP / TB / 局部集成使用，提供 source/sink/monitor modport。
// 不在此处实现协议断言（SVA 归对应 VIP Core）。

interface aix_ready_valid_if #(
  parameter int unsigned DATA_W = 32,
  parameter int unsigned USER_W = 1,
  parameter logic         EN_KEEP = 1'b0,
  parameter logic         EN_LAST = 1'b0,
  parameter logic         EN_USER = 1'b0
) (
  input logic clk,
  input logic rst_n
);

  logic                  valid;
  logic                  ready;
  logic [DATA_W-1:0]     data;
  logic [DATA_W/8-1:0]   keep;
  logic                  last;
  logic [USER_W-1:0]     user;

  // 默认 tie-off：未使能的可选信号按规范 clamp
  assign keep = '0;
  assign last = 1'b0;
  assign user = '0;

  modport source (output valid, data, keep, last, user,
                  input  ready);
  modport sink   (input  valid, data, keep, last, user,
                  output ready);
  modport monitor(input  valid, ready, data, keep, last, user);

  // 可选信号的 modport 变体由工具按 Profile 生成；
  // 当 EN_* 关闭时，对应信号为 tie-off 常量（见上方 assign）。

endinterface : aix_ready_valid_if
