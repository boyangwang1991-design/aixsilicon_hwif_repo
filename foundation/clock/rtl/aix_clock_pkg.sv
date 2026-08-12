// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_clock_pkg: 时钟接口类型与元数据。
// 时钟线通常为单比特物理信号，packed struct 主要用于元数据传递。

package aix_clock_pkg;

  // 时钟门控使能
  typedef struct packed {
    logic clk_en;
    logic clk_gen; // 派生时钟标识
  } clock_ctl_t;

  // 频率元数据（供 SoCGen / 功耗工具读取，非 RTL 可综合对象）
  typedef struct packed {
    logic [31:0] freq_hz;
  } clock_meta_t;

  localparam logic [31:0] CLK_FREQ_UNCONSTRAINED = 32'h0;

endpackage : aix_clock_pkg
