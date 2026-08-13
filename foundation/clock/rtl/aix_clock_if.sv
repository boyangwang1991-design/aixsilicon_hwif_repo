// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_clock_if: 时钟接口（View B）。
// controller 提供时钟与门控使能；endpoint 消费。

interface aix_clock_if (
  input logic clk
);

  logic clk_en;  // 1: 时钟运行；0: 时钟保持无效电平（门控）
  logic clk_gen; // 1: 该时钟为派生时钟

  // clk 为 interface 端口（input），两端 modport 均不重声明其方向
  modport controller (output clk_en, clk_gen);
  modport endpoint   (input  clk_en, clk_gen);

endinterface : aix_clock_if
