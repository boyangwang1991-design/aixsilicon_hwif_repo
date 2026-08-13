// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_trace_stream_pkg: 跟踪流 req/rsp 聚合结构（View A）。
// 信号集对齐 dft_debug/trace_stream/contract/trace_stream.interface.yaml（IFC-TRACE-001）。

package aix_trace_stream_pkg;

  localparam int unsigned TRACE_DATA_W   = 64;
  localparam int unsigned TRACE_SOURCE_W = 8;

  // 跟踪通道（source -> sink，ready/valid 独立）
  typedef struct packed {
    logic [TRACE_DATA_W-1:0]   data;
    logic [TRACE_SOURCE_W-1:0] source;
    logic                      overflow;
    logic                      valid;
    logic                      ready;
  } trace_stream_t;

endpackage : aix_trace_stream_pkg
