// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_mgmt_if: HAC-MGMT 管理接口（View B）。
// shell（HAC Shell / Power-Reset Manager）与 core（HAC Core）连接。

interface aix_hac_mgmt_if #(
  parameter logic EN_DRAIN    = 1'b1,
  parameter logic EN_ISOLATE  = 1'b0,
  parameter logic EN_CLK_GATE = 1'b1
) (
  input logic clk,
  input logic rst_n
);

  logic reset_req;
  logic reset_ack;
  logic drain_req;
  logic drain_ack;
  logic isolate_req;
  logic isolate_ack;

  logic quiescent;
  logic idle;
  logic clock_gate_ok;
  logic fatal_state;

  // 可选信号 tie-off
  assign drain_req    = 1'b0;
  assign drain_ack    = 1'b0;
  assign isolate_req  = 1'b0;
  assign isolate_ack  = 1'b0;
  assign clock_gate_ok = 1'b1;

  modport shell (
    output reset_req, drain_req, isolate_req,
    input  reset_ack, drain_ack, isolate_ack,
           quiescent, idle, clock_gate_ok, fatal_state
  );

  modport core (
    input  reset_req, drain_req, isolate_req,
    output reset_ack, drain_ack, isolate_ack,
           quiescent, idle, clock_gate_ok, fatal_state
  );

  modport monitor (
    input  reset_req, reset_ack, drain_req, drain_ack,
           isolate_req, isolate_ack, quiescent, idle, clock_gate_ok, fatal_state
  );

endinterface : aix_hac_mgmt_if
