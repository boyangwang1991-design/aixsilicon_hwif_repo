// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_performance_event_if: 性能事件接口（View B）。
// 信号集对齐 dft_debug/performance_event/contract/performance_event.interface.yaml（IFC-PERF-001）。
// event_count 为可选 count_events 能力信号。

interface aix_performance_event_if #(
  parameter int unsigned EVENT_ID_W = 8,
  parameter int unsigned EVENT_NUM  = 16
) (
  input logic clk,
  input logic rst_n
);

  logic [EVENT_ID_W-1:0] event_id;
  logic [EVENT_NUM-1:0]  event_pulse;
  logic [EVENT_NUM-1:0]  event_count; // capability: count_events（可选）

  modport source (
    output event_id, event_pulse, event_count
  );
  modport sink (
    input  event_id, event_pulse, event_count
  );

endinterface : aix_performance_event_if
