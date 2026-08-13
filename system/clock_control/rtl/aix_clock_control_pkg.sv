// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_clock_control_pkg: 时钟控制 req/rsp 聚合结构（View A）。
// 信号集对齐 system/clock_control/contract/clock_control.interface.yaml（IFC-CC-001）。

package aix_clock_control_pkg;

  // 控制通道（controller -> endpoint）
  typedef struct packed {
    logic clk_en_req;
    logic clk_switch_req; // capability: mux_switch（可选）
  } clock_control_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic clk_en_ack;
    logic clk_gate_status;
    logic clk_switch_ack; // capability: mux_switch（可选）
  } clock_control_rsp_t;

endpackage : aix_clock_control_pkg
