// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_lifecycle_state_if: 安全生命周期状态接口（View B）。
// 信号集对齐 system/lifecycle_state/contract/lifecycle_state.interface.yaml（IFC-LS-001）。

interface aix_lifecycle_state_if #(
  parameter int unsigned STATE_W = 8
) (
  input logic clk,
  input logic rst_n
);

  logic [STATE_W-1:0] lc_state_req;
  logic               lc_state_ack;
  logic [STATE_W-1:0] lc_state;
  logic               lc_state_valid;

  modport controller (
    output lc_state_req,
    input  lc_state_ack, lc_state, lc_state_valid
  );
  modport endpoint (
    input  lc_state_req,
    output lc_state_ack, lc_state, lc_state_valid
  );

endinterface : aix_lifecycle_state_if
