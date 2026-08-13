// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_trace_stream_if: 跟踪流接口（View B）。
// 信号集对齐 dft_debug/trace_stream/contract/trace_stream.interface.yaml（IFC-TRACE-001）。

interface aix_trace_stream_if #(
  parameter int unsigned DATA_W   = 64,
  parameter int unsigned SOURCE_W = 8
) (
  input logic clk,
  input logic rst_n
);

  logic                   trace_valid;
  logic                   trace_ready;
  logic [DATA_W-1:0]      trace_data;
  logic [SOURCE_W-1:0]    trace_source;
  logic                   trace_overflow;

  modport source (
    output trace_valid, trace_data, trace_source, trace_overflow,
    input  trace_ready
  );
  modport sink (
    input  trace_valid, trace_data, trace_source, trace_overflow,
    output trace_ready
  );

endinterface : aix_trace_stream_if
