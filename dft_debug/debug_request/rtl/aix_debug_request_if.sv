// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_debug_request_if: 调试请求接口（View B）。
// 信号集对齐 dft_debug/debug_request/contract/debug_request.interface.yaml（IFC-DBG-001）。

interface aix_debug_request_if (
  input logic clk,
  input logic rst_n
);

  logic       halt_req;
  logic       resume_req;
  logic       step_req;
  logic [1:0] debug_status;

  modport controller (
    output halt_req, resume_req, step_req,
    input  debug_status
  );
  modport endpoint (
    input  halt_req, resume_req, step_req,
    output debug_status
  );

endinterface : aix_debug_request_if
