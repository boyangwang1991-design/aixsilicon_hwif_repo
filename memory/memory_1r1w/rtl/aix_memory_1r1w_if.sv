// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_memory_1r1w_if: 独立读写端口内存接口（View B）。

interface aix_memory_1r1w_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  // write port
  logic                    wreq_valid;
  logic                    wreq_ready;
  logic [ADDR_W-1:0]       waddr;
  logic [DATA_W-1:0]       wdata;
  logic [DATA_W/8-1:0]     wbe;

  // read port
  logic                    rreq_valid;
  logic                    rreq_ready;
  logic [ADDR_W-1:0]       raddr;
  logic                    rsp_valid;
  logic [DATA_W-1:0]       rdata;

  modport requester (
    output wreq_valid, waddr, wdata, wbe,
           rreq_valid, raddr,
    input  wreq_ready, rreq_ready, rsp_valid, rdata
  );
  modport memory (
    input  wreq_valid, waddr, wdata, wbe,
           rreq_valid, raddr,
    output wreq_ready, rreq_ready, rsp_valid, rdata
  );

endinterface : aix_memory_1r1w_if
