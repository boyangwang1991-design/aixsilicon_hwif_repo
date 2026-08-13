// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_obi_if: RISC-V OBI 接口（View B）。
// 信号集对齐 bus/obi/contract/obi.interface.yaml（IFC-OBI-001）。

interface aix_obi_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  // Request channel（initiator -> target）
  logic                   req_valid;
  logic                   req_ready;
  logic [ADDR_W-1:0]      req_addr;
  logic [DATA_W-1:0]      req_wdata;
  logic                   req_we;
  logic [DATA_W/8-1:0]    req_be;
  // Response channel（target -> initiator）
  logic                   rsp_valid;
  logic                   rsp_ready;
  logic [DATA_W-1:0]      rsp_rdata;
  logic                   rsp_err;

  modport initiator (
    output req_valid, req_addr, req_wdata, req_we, req_be,
           rsp_ready,
    input  req_ready, rsp_valid, rsp_rdata, rsp_err
  );
  modport target (
    input  req_valid, req_addr, req_wdata, req_we, req_be,
           rsp_ready,
    output req_ready, rsp_valid, rsp_rdata, rsp_err
  );
  modport monitor (
    input req_valid, req_ready, req_addr, req_wdata, req_we, req_be,
          rsp_valid, rsp_ready, rsp_rdata, rsp_err
  );

endinterface : aix_obi_if
