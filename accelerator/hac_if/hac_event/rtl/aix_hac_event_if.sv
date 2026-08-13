// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_event_if: HAC-EVENT 事件接口（View B）。
// core（HAC Core 产生事件）与 shell（HAC Shell/IRQ Controller）连接。

interface aix_hac_event_if #(
  parameter int unsigned EVENT_TYPE_W = 3,
  parameter int unsigned SEVERITY_W   = 2,
  parameter int unsigned SOURCE_W     = 8,
  parameter int unsigned JOB_ID_W     = 8,
  parameter int unsigned CODE_W       = 16,
  parameter int unsigned INFO_W       = 32,
  parameter logic         EN_JOB = 1'b1,
  parameter logic         EN_INFO = 1'b1
) (
  input logic clk,
  input logic rst_n
);

  logic                event_valid;
  logic                event_ready;
  logic [EVENT_TYPE_W-1:0] event_type;
  logic [SEVERITY_W-1:0]   severity;
  logic [SOURCE_W-1:0]     source;
  logic [JOB_ID_W-1:0]     job_id;
  logic [CODE_W-1:0]       code;
  logic [INFO_W-1:0]       info;

  // 可选信号 tie-off
  assign job_id = '0;
  assign info   = '0;

  modport core (
    output event_valid, event_type, severity, source, job_id, code, info,
    input  event_ready
  );

  modport shell (
    input  event_valid, event_type, severity, source, job_id, code, info,
    output event_ready
  );

  modport monitor (
    input  event_valid, event_ready, event_type, severity, source, job_id, code, info
  );

endinterface : aix_hac_event_if
