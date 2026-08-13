// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_power_state_pkg: 电源状态 req/rsp 聚合结构（View A）。
// 信号集对齐 system/power_state/contract/power_state.interface.yaml（IFC-PW-001）。

package aix_power_state_pkg;

  localparam int unsigned PWR_STATE_W = 4;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic [PWR_STATE_W-1:0] pwr_state_req;
  } power_state_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic                   pwr_state_ack;
    logic [PWR_STATE_W-1:0] pwr_state;
    logic                   wake_event; // capability: wake（可选）
  } power_state_rsp_t;

endpackage : aix_power_state_pkg
