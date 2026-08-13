// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_lockstep_compare_if: 锁步比较接口（View B）。
// 信号集对齐 safety_security/lockstep_compare/contract/lockstep_compare.interface.yaml（IFC-LSC-001）。

interface aix_lockstep_compare_if #(
  parameter int unsigned CHANNEL_W = 8,
  parameter int unsigned SYNDROME_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic                   compare_en;
  logic                   mismatch;
  logic [SYNDROME_W-1:0]  mismatch_syndrome;
  logic [CHANNEL_W-1:0]   mismatch_channel;

  modport controller (
    output compare_en,
    input  mismatch, mismatch_syndrome, mismatch_channel
  );
  modport endpoint (
    input  compare_en,
    output mismatch, mismatch_syndrome, mismatch_channel
  );

endinterface : aix_lockstep_compare_if
