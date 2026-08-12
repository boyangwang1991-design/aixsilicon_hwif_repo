// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_reg_native_if: 简化寄存器接口（View B）。

interface aix_reg_native_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic                    req_valid;
  logic                    req_ready;
  logic [ADDR_W-1:0]       addr;
  logic [DATA_W-1:0]       wdata;
  logic                    we;
  logic [DATA_W/8-1:0]     be;
  logic                    rsp_valid;
  logic                    rsp_ready;
  logic [DATA_W-1:0]       rdata;
  logic                    err;

  modport initiator (
    output req_valid, addr, wdata, we, be, rsp_ready,
    input  req_ready, rsp_valid, rdata, err
  );
  modport target (
    input  req_valid, addr, wdata, we, be, rsp_ready,
    output req_ready, rsp_valid, rdata, err
  );

endinterface : aix_reg_native_if
