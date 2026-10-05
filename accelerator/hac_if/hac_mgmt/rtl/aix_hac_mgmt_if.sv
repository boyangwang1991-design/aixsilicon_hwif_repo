// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_mgmt_if: 由 tools/view_generate/view_generate.py 从 YAML Contract 确定性生成。
// 契约来源：IFC-HAC_MGMT-001。禁止手工修改，改契约后重新生成。

interface aix_hac_mgmt_if (
  input  logic clk,
  input  logic rst_n
);

  logic reset_req; // channel=reset_ctrl
  logic reset_ack; // channel=reset_ctrl
  logic drain_req; // channel=drain_ctrl
  logic drain_ack; // channel=drain_ctrl
  logic isolate_req; // channel=isolate_ctrl
  logic isolate_ack; // channel=isolate_ctrl
  logic quiescent; // channel=status
  logic idle; // channel=status
  logic clock_gate_ok; // channel=status
  logic fatal_state; // channel=status

  modport shell (
    output reset_req , drain_req , isolate_req,
    input  reset_ack , drain_ack , isolate_ack , quiescent , idle , clock_gate_ok , fatal_state
  );

  modport core (
    output reset_ack , drain_ack , isolate_ack , quiescent , idle , clock_gate_ok , fatal_state,
    input  reset_req , drain_req , isolate_req
  );

endinterface : aix_hac_mgmt_if
