// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_event_if: 事件接口（View B）。
// 可选 ack 用于 level 型事件。

interface aix_event_if (
  input logic clk,
  input logic rst_n
);

  logic event_pulse;
  logic event_ack;

  modport source   (output event_pulse, input  event_ack);
  modport receiver (input  event_pulse, output event_ack);

endinterface : aix_event_if
