// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_ecc_memory_sideband_if: 存储 ECC 侧带接口（View B）。
// 信号集对齐 memory/ecc_memory_sideband/contract/ecc_memory_sideband.interface.yaml（IFC-ECC-SB-001）。
// ecc_inject 为可选 injection 能力信号。

interface aix_ecc_memory_sideband_if #(
  parameter int unsigned SYNDROME_W = 8
) (
  input logic clk,
  input logic rst_n
);

  logic                 ecc_valid;
  logic                 ecc_ready;
  logic                 ecc_corrected;
  logic                 ecc_uncorrectable;
  logic [SYNDROME_W-1:0] ecc_syndrome;
  logic                 ecc_inject; // capability: injection（可选）

  modport requester (
    input  ecc_valid, ecc_corrected, ecc_uncorrectable, ecc_syndrome,
    output ecc_ready, ecc_inject
  );
  modport memory (
    output ecc_valid, ecc_corrected, ecc_uncorrectable, ecc_syndrome,
    input  ecc_ready, ecc_inject
  );

endinterface : aix_ecc_memory_sideband_if
