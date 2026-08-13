// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_lmem_if: HAC-LMEM 本地存储接口（View B）。
// core（HAC Core 访问本地存储）与 lmem（SRAM/Bank/ECC Wrapper）连接。

interface aix_hac_lmem_if #(
  parameter int unsigned DATA_W  = 64,
  parameter int unsigned ADDR_W  = 16,
  parameter int unsigned BANK_W  = 2,
  parameter int unsigned TAG_W   = 4,
  parameter logic         EN_BANK    = 1'b0,
  parameter logic         EN_DECOUPL = 1'b0,
  parameter logic         EN_ECC     = 1'b0
) (
  input logic clk,
  input logic rst_n
);

  logic                req_valid;
  logic                req_ready;
  logic                write;
  logic [BANK_W-1:0]   bank;
  logic [ADDR_W-1:0]   addr;
  logic [DATA_W-1:0]   wdata;
  logic [DATA_W/8-1:0] wstrb;
  logic [TAG_W-1:0]    req_tag;

  logic                rsp_valid;
  logic                rsp_ready;
  logic [DATA_W-1:0]   rdata;
  logic [TAG_W-1:0]    rsp_tag;
  logic                ecc_corrected;
  logic                ecc_uncorrectable;

  // 可选信号 tie-off
  assign bank            = '0;
  assign req_tag         = '0;
  assign rsp_tag         = '0;
  assign ecc_corrected   = 1'b0;
  assign ecc_uncorrectable = 1'b0;

  modport core (
    output req_valid, write, bank, addr, wdata, wstrb, req_tag, rsp_ready,
    input  req_ready, rsp_valid, rdata, rsp_tag, ecc_corrected, ecc_uncorrectable
  );

  modport lmem (
    input  req_valid, write, bank, addr, wdata, wstrb, req_tag, rsp_ready,
    output req_ready, rsp_valid, rdata, rsp_tag, ecc_corrected, ecc_uncorrectable
  );

  modport monitor (
    input  req_valid, req_ready, write, bank, addr, wdata, wstrb, req_tag,
           rsp_valid, rsp_ready, rdata, rsp_tag, ecc_corrected, ecc_uncorrectable
  );

endinterface : aix_hac_lmem_if
