// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_performance_event_pkg: 性能事件聚合结构（View A）。
// 信号集对齐 dft_debug/performance_event/contract/performance_event.interface.yaml（IFC-PERF-001）。

package aix_performance_event_pkg;

  localparam int unsigned PERF_EVENT_ID_W = 8;
  localparam int unsigned PERF_EVENT_NUM  = 16;

  // 事件（source -> sink）
  typedef struct packed {
    logic [PERF_EVENT_ID_W-1:0] event_id;
    logic [PERF_EVENT_NUM-1:0]  event_pulse;
    logic [PERF_EVENT_NUM-1:0]  event_count; // capability: count_events（可选）
  } performance_event_t;

endpackage : aix_performance_event_pkg
