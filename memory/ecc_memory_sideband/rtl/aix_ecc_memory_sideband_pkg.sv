// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_ecc_memory_sideband_pkg: 存储 ECC 侧带 req/rsp 聚合结构（View A）。
// 信号集对齐 memory/ecc_memory_sideband/contract/ecc_memory_sideband.interface.yaml（IFC-ECC-SB-001）。

package aix_ecc_memory_sideband_pkg;

  localparam int unsigned ECC_SYNDROME_W = 8;

  // ECC 事件（memory -> requester）
  typedef struct packed {
    logic                       ecc_valid;
    logic                       ecc_ready;
    logic                       ecc_corrected;
    logic                       ecc_uncorrectable;
    logic [ECC_SYNDROME_W-1:0]  ecc_syndrome;
    logic                       ecc_inject; // capability: injection（可选）
  } ecc_sideband_t;

endpackage : aix_ecc_memory_sideband_pkg
