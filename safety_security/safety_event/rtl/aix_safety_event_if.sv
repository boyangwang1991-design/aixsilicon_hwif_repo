// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_safety_event_if: 安全事件接口（View B）。

interface aix_safety_event_if #(
  parameter int unsigned FAULT_ID_W = 16,
  parameter int unsigned TIMESTAMP_W = 32,
  parameter int unsigned DOMAIN_W = 8
) (
  input logic clk,
  input logic rst_n
);

  logic                     ev_valid;
  logic                     ev_ready;
  logic [FAULT_ID_W-1:0]    ev_fault_id;
  logic                     ev_severity;
  logic [DOMAIN_W-1:0]      ev_domain;
  logic [TIMESTAMP_W-1:0]   ev_timestamp;
  logic                     ev_ack;

  modport source (
    output ev_valid, ev_fault_id, ev_severity, ev_domain, ev_timestamp,
    input  ev_ready, ev_ack
  );
  modport receiver (
    input  ev_valid, ev_fault_id, ev_severity, ev_domain, ev_timestamp,
    output ev_ready, ev_ack
  );

endinterface : aix_safety_event_if
