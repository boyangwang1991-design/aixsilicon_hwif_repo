// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_scan_control_if: 扫描测试控制接口（View B）。
// 信号集对齐 dft_debug/scan_control/contract/scan_control.interface.yaml（IFC-SCAN-001）。

interface aix_scan_control_if (
  input logic clk,
  input logic rst_n
);

  logic scan_enable;
  logic test_mode;
  logic scan_clk;
  logic scan_rst;

  modport controller (
    output scan_enable, test_mode, scan_clk, scan_rst
  );
  modport endpoint (
    input  scan_enable, test_mode, scan_clk, scan_rst
  );

endinterface : aix_scan_control_if
