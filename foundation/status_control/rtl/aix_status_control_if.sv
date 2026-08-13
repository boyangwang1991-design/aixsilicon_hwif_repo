// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_status_control_if: 状态/控制接口（View B）。
// 信号集对齐 foundation/status_control/contract/status_control.interface.yaml（IFC-STATUS-001）。
// error 为可选 error_report 能力信号。

interface aix_status_control_if (
  input logic clk,
  input logic rst_n
);

  logic enable;
  logic busy;
  logic done;
  logic idle;
  logic error; // capability: error_report（可选）

  modport controller (
    output enable,
    input  busy, done, idle, error
  );
  modport endpoint (
    input  enable,
    output busy, done, idle, error
  );

endinterface : aix_status_control_if
