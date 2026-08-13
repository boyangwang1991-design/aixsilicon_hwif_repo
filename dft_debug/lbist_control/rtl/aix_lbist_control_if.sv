// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_lbist_control_if: 逻辑 BIST 控制接口（View B）。
// 信号集对齐 dft_debug/lbist_control/contract/lbist_control.interface.yaml（IFC-LBIST-001）。

interface aix_lbist_control_if #(
  parameter int unsigned SIGNATURE_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic             start;
  logic             done;
  logic             pass;
  logic             fail;
  logic [SIGNATURE_W-1:0] signature;

  modport controller (
    output start,
    input  done, pass, fail, signature
  );
  modport endpoint (
    input  start,
    output done, pass, fail, signature
  );

endinterface : aix_lbist_control_if
