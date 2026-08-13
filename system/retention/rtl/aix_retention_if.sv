// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_retention_if: 数据保持接口（View B）。
// 信号集对齐 system/retention/contract/retention.interface.yaml（IFC-RET-001）。
// retention_ctrl 为可选 ctrl_override 能力信号。

interface aix_retention_if #(
  parameter int unsigned RETENTION_CTRL_W = 8
) (
  input logic clk,
  input logic rst_n
);

  logic                         save_req;
  logic                         restore_req;
  logic                         retention_ack;
  logic                         retention_status;
  logic [RETENTION_CTRL_W-1:0]  retention_ctrl; // capability: ctrl_override（可选）

  modport controller (
    output save_req, restore_req, retention_ctrl,
    input  retention_ack, retention_status
  );
  modport endpoint (
    input  save_req, restore_req, retention_ctrl,
    output retention_ack, retention_status
  );

endinterface : aix_retention_if
