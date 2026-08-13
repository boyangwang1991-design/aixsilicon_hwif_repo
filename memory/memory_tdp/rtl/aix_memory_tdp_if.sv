// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_memory_tdp_if: 真双端口存储接口（View B）。
// 信号集对齐 memory/memory_tdp/contract/memory_tdp.interface.yaml（IFC-MEM-TDP-001）。

interface aix_memory_tdp_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 64
) (
  input logic clk,
  input logic rst_n
);

  // Port A
  logic              a_valid;
  logic              a_ready;
  logic [ADDR_W-1:0] a_addr;
  logic              a_we;
  logic [DATA_W-1:0] a_wdata;
  logic [DATA_W-1:0] a_rdata;
  // Port B
  logic              b_valid;
  logic              b_ready;
  logic [ADDR_W-1:0] b_addr;
  logic              b_we;
  logic [DATA_W-1:0] b_wdata;
  logic [DATA_W-1:0] b_rdata;

  modport requester_a (
    output a_valid, a_addr, a_we, a_wdata,
    input  a_ready, a_rdata
  );
  modport requester_b (
    output b_valid, b_addr, b_we, b_wdata,
    input  b_ready, b_rdata
  );
  modport memory (
    input  a_valid, a_addr, a_we, a_wdata, b_valid, b_addr, b_we, b_wdata,
    output a_ready, a_rdata, b_ready, b_rdata
  );

endinterface : aix_memory_tdp_if
