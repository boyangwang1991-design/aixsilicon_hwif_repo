// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_pll_control_if: PLL 控制接口（View B）。
// 信号集对齐 peripheral/pll_control/contract/pll_control.interface.yaml（IFC-PLL-001）。
// pll_bypass / pll_cfg 为可选能力信号。

interface aix_pll_control_if (
  input logic clk,
  input logic rst_n
);

  logic       pll_ref_clk;
  logic       pll_enable;
  logic       pll_lock;
  logic       pll_bypass; // capability: bypass（可选）
  logic [31:0] pll_cfg;   // capability: config（可选）

  modport controller (
    output pll_ref_clk, pll_enable, pll_bypass, pll_cfg,
    input  pll_lock
  );
  modport endpoint (
    input  pll_ref_clk, pll_enable, pll_bypass, pll_cfg,
    output pll_lock
  );

endinterface : aix_pll_control_if
