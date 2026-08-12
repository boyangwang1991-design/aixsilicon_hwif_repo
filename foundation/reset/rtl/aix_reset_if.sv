// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_reset_if: 复位接口（View B）。
// controller 输出复位；endpoint 消费复位与复位请求。

interface aix_reset_if (
  input logic clk
);

  logic rst;      // 复位线（极性由参数/Profile 决定）
  logic rst_req;  // 可选：请求复位

  modport controller (output rst, rst_req);
  modport endpoint   (input  rst, rst_req);

endinterface : aix_reset_if
