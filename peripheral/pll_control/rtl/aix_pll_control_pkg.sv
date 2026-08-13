// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_pll_control_pkg: PLL 控制 req/rsp 聚合结构（View A）。
// 信号集对齐 peripheral/pll_control/contract/pll_control.interface.yaml（IFC-PLL-001）。

package aix_pll_control_pkg;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic       pll_ref_clk;
    logic       pll_enable;
    logic       pll_bypass; // capability: bypass（可选）
    logic [31:0] pll_cfg;   // capability: config（可选）
  } pll_control_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic pll_lock;
  } pll_control_rsp_t;

endpackage : aix_pll_control_pkg
