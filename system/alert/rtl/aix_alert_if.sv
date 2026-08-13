// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_alert_if: 安全敏感事件 alert 接口（View B）。
// 信号集对齐 system/alert/contract/alert.interface.yaml（IFC-ALERT-001）。
// alert_ping / alert_heartbeat_ok 为可选 heartbeat 能力信号。

interface aix_alert_if #(
  parameter int unsigned ALERT_W = 1
) (
  input logic clk,
  input logic rst_n
);

  logic [ALERT_W-1:0] alert_valid;
  logic [ALERT_W-1:0] alert_ack;
  logic [ALERT_W-1:0] alert_ping;         // capability: heartbeat（可选）
  logic [ALERT_W-1:0] alert_heartbeat_ok; // capability: heartbeat（可选）

  modport source (
    output alert_valid, alert_heartbeat_ok,
    input  alert_ack, alert_ping
  );
  modport receiver (
    input  alert_valid, alert_heartbeat_ok,
    output alert_ack, alert_ping
  );

endinterface : aix_alert_if
