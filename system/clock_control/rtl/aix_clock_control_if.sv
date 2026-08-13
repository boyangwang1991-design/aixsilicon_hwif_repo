// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_clock_control_if: 时钟控制接口（View B）。
// 信号集对齐 system/clock_control/contract/clock_control.interface.yaml（IFC-CC-001）。
// clk_switch_req/ack 为可选 mux_switch 能力信号。

interface aix_clock_control_if (
  input logic clk,
  input logic rst_n
);

  logic clk_en_req;
  logic clk_en_ack;
  logic clk_gate_status;
  logic clk_switch_req; // capability: mux_switch（可选）
  logic clk_switch_ack; // capability: mux_switch（可选）

  modport controller (
    output clk_en_req, clk_switch_req,
    input  clk_en_ack, clk_gate_status, clk_switch_ack
  );
  modport endpoint (
    input  clk_en_req, clk_switch_req,
    output clk_en_ack, clk_gate_status, clk_switch_ack
  );

endinterface : aix_clock_control_if
