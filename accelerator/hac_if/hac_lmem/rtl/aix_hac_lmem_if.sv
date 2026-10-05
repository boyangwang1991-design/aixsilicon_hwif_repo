// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_lmem_if: 由 tools/view_generate/view_generate.py 从 YAML Contract 确定性生成。
// 契约来源：IFC-HAC_LMEM-001。禁止手工修改，改契约后重新生成。

interface aix_hac_lmem_if#(
  parameter int unsigned DATA_W = 64,
  parameter int unsigned ADDR_W = 16,
  parameter int unsigned BANK_W = 1,
  parameter int unsigned TAG_W = 4,
  parameter int unsigned MAX_OUTSTANDING = 1,
  parameter int unsigned READ_LATENCY = 1
) (
  input  logic clk,
  input  logic rst_n
);

  logic req_valid; // channel=req
  logic req_ready; // channel=req
  logic write; // channel=req
  logic [BANK_W-1:0] bank; // channel=req
  logic [ADDR_W-1:0] addr; // channel=req
  logic [DATA_W-1:0] wdata; // channel=req
  logic [DATA_W/8-1:0] wstrb; // channel=req
  logic [TAG_W-1:0] req_tag; // channel=req
  logic rsp_valid; // channel=rsp
  logic rsp_ready; // channel=rsp
  logic [DATA_W-1:0] rdata; // channel=rsp
  logic [3:0] rsp_status; // channel=rsp
  logic [TAG_W-1:0] rsp_tag; // channel=rsp
  logic ecc_corrected; // channel=rsp
  logic ecc_uncorrectable; // channel=rsp

  modport core (
    output req_valid , write , bank , addr , wdata , wstrb , req_tag , rsp_ready,
    input  req_ready , rsp_valid , rdata , rsp_status , rsp_tag , ecc_corrected , ecc_uncorrectable
  );

  modport lmem (
    output req_ready , rsp_valid , rdata , rsp_status , rsp_tag , ecc_corrected , ecc_uncorrectable,
    input  req_valid , write , bank , addr , wdata , wstrb , req_tag , rsp_ready
  );

endinterface : aix_hac_lmem_if
