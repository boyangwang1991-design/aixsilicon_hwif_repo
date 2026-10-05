// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_event_if: 由 tools/view_generate/view_generate.py 从 YAML Contract 确定性生成。
// 契约来源：IFC-HAC_EVT-001。禁止手工修改，改契约后重新生成。

interface aix_hac_event_if#(
  parameter int unsigned EVENT_TYPE_W = 3,
  parameter int unsigned SEVERITY_W = 2,
  parameter int unsigned SOURCE_W = 8,
  parameter int unsigned JOB_ID_W = 8,
  parameter int unsigned CODE_W = 16,
  parameter int unsigned INFO_W = 32
) (
  input  logic clk,
  input  logic rst_n
);

  logic event_valid; // channel=event
  logic event_ready; // channel=event
  logic [EVENT_TYPE_W-1:0] event_type; // channel=event
  logic [SEVERITY_W-1:0] severity; // channel=event
  logic [SOURCE_W-1:0] source; // channel=event
  logic [JOB_ID_W-1:0] job_id; // channel=event
  logic [CODE_W-1:0] code; // channel=event
  logic [INFO_W-1:0] info; // channel=event

  modport core (
    output event_valid , event_type , severity , source , job_id , code , info,
    input  event_ready
  );

  modport shell (
    output event_ready,
    input  event_valid , event_type , severity , source , job_id , code , info
  );

endinterface : aix_hac_event_if
