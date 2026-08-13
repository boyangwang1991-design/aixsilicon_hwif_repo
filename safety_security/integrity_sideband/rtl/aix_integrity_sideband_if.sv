// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_integrity_sideband_if: 数据完整性侧带接口（View B）。
// 信号集对齐 safety_security/integrity_sideband/contract/integrity_sideband.interface.yaml（IFC-INT-SB-001）。
// poison 为可选能力信号。

interface aix_integrity_sideband_if #(
  parameter int unsigned WIDTH   = 64,
  parameter int unsigned CHECK_W = 8
) (
  input logic clk,
  input logic rst_n
);

  logic              valid;
  logic              ready;
  logic [WIDTH-1:0]  data;
  logic [CHECK_W-1:0] check;
  logic              poison; // capability: poison（可选）

  modport source (
    output data, check, valid, poison,
    input  ready
  );
  modport sink (
    input  data, check, valid, poison,
    output ready
  );

endinterface : aix_integrity_sideband_if
