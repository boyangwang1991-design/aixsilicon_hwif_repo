// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_memory_1rw_if: 单端口内存接口（View B）。

interface aix_memory_1rw_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic                    req_valid;
  logic                    req_ready;
  logic [ADDR_W-1:0]       addr;
  logic                    we;
  logic [DATA_W-1:0]       wdata;
  logic [DATA_W/8-1:0]     be;
  logic                    rsp_valid;
  logic [DATA_W-1:0]       rdata;

  modport requester (
    output req_valid, addr, we, wdata, be,
    input  req_ready, rsp_valid, rdata
  );
  modport memory (
    input  req_valid, addr, we, wdata, be,
    output req_ready, rsp_valid, rdata
  );

endinterface : aix_memory_1rw_if
