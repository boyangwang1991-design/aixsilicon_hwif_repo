// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_integrity_sideband_pkg: 数据完整性侧带聚合结构（View A）。
// 信号集对齐 safety_security/integrity_sideband/contract/integrity_sideband.interface.yaml（IFC-INT-SB-001）。

package aix_integrity_sideband_pkg;

  localparam int unsigned INT_SB_DATA_W  = 64;
  localparam int unsigned INT_SB_CHECK_W = 8;

  // 完整性通道（source -> sink，ready/valid 独立）
  typedef struct packed {
    logic [INT_SB_DATA_W-1:0]  data;
    logic [INT_SB_CHECK_W-1:0] check;
    logic                      valid;
    logic                      ready;
    logic                      poison; // capability: poison（可选）
  } integrity_sideband_t;

endpackage : aix_integrity_sideband_pkg
