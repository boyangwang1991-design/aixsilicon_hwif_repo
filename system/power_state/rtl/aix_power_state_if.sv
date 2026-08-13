// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_power_state_if: 电源状态接口（View B）。
// 信号集对齐 system/power_state/contract/power_state.interface.yaml（IFC-PW-001）。
// wake_event 为可选 wake 能力信号。

interface aix_power_state_if #(
  parameter int unsigned STATE_W = 4
) (
  input logic clk,
  input logic rst_n
);

  logic [STATE_W-1:0] pwr_state_req;
  logic               pwr_state_ack;
  logic [STATE_W-1:0] pwr_state;
  logic               wake_event; // capability: wake（可选）

  modport controller (
    output pwr_state_req,
    input  pwr_state_ack, pwr_state, wake_event
  );
  modport endpoint (
    input  pwr_state_req,
    output pwr_state_ack, pwr_state, wake_event
  );

endinterface : aix_power_state_if
