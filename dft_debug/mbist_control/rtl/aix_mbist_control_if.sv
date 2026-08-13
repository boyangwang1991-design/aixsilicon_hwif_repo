// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_mbist_control_if: MBIST 控制接口（View B）。
// 信号集对齐 dft_debug/mbist_control/contract/mbist_control.interface.yaml（IFC-MBIST-001）。
// fail_addr/syndrome 为可选能力信号（addr_report / syndrome_report）。

interface aix_mbist_control_if #(
  parameter int unsigned ADDR_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic             start;
  logic             done;
  logic             fail;
  logic [ADDR_W-1:0] fail_addr; // capability: addr_report（可选）
  logic [7:0]        syndrome;  // capability: syndrome_report（可选）

  modport controller (
    output start,
    input  done, fail, fail_addr, syndrome
  );
  modport endpoint (
    input  start,
    output done, fail, fail_addr, syndrome
  );

endinterface : aix_mbist_control_if
