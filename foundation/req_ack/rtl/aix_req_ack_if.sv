// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_req_ack_if: request/acknowledge 事件接口（View B）。

interface aix_req_ack_if (
  input logic clk,
  input logic rst_n
);

  logic req;
  logic ack;

  modport initiator (output req, input ack);
  modport target    (input  req, output ack);

endinterface : aix_req_ack_if
