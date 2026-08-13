// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_reset_control_if: 复位控制接口（View B）。
// 信号集对齐 system/reset_control/contract/reset_control.interface.yaml（IFC-RSTC-001）。
// reset_cause 为可选 cause_report 能力信号。

interface aix_reset_control_if (
  input logic clk,
  input logic rst_n
);

  logic       reset_req;
  logic       reset_ack;
  logic       reset_status;
  logic [7:0] reset_cause; // capability: cause_report（可选）

  modport controller (
    output reset_req,
    input  reset_ack, reset_status, reset_cause
  );
  modport endpoint (
    input  reset_req,
    output reset_ack, reset_status, reset_cause
  );

endinterface : aix_reset_control_if
