// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_apb_if: APB 接口（View B）。

interface aix_apb_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic                    psel;
  logic                    penable;
  logic [ADDR_W-1:0]       paddr;
  logic                    pwrite;
  logic [DATA_W-1:0]       pwdata;
  logic [DATA_W/8-1:0]     pstrb;
  logic [2:0]              pprot;
  logic [DATA_W-1:0]       prdata;
  logic                    pready;
  logic                    pslverr;

  modport initiator (
    output psel, penable, paddr, pwrite, pwdata, pstrb, pprot,
    input  prdata, pready, pslverr
  );
  modport target (
    input  psel, penable, paddr, pwrite, pwdata, pstrb, pprot,
    output prdata, pready, pslverr
  );

endinterface : aix_apb_if
