// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_mem_if: HAC-MEM 系统访存接口（View B）。
// core（HAC Core 发起访存）与 adapter（HAC Shell/AXI Adapter）连接。

interface aix_hac_mem_if #(
  parameter int unsigned ADDR_W   = 64,
  parameter int unsigned DATA_W   = 128,
  parameter int unsigned LEN_W    = 16,
  parameter int unsigned TAG_W    = 6,
  parameter int unsigned JOB_ID_W = 8,
  parameter int unsigned ATTR_W   = 8,
  parameter logic         EN_JOB  = 1'b0,
  parameter logic         EN_ATTR = 1'b1
) (
  input logic clk,
  input logic rst_n
);

  // Read Request
  logic                req_valid;
  logic                req_ready;
  logic [2:0]          req_opcode;
  logic [ADDR_W-1:0]   req_addr;
  logic [LEN_W-1:0]    req_len;
  logic [TAG_W-1:0]    req_tag;
  logic [JOB_ID_W-1:0] req_job_id;
  logic [ATTR_W-1:0]   req_attr;

  // Read Response
  logic                rsp_valid;
  logic                rsp_ready;
  logic [DATA_W-1:0]   rsp_data;
  logic [TAG_W-1:0]    rsp_tag;
  logic                rsp_last;
  logic [3:0]          rsp_status;

  // Write Request + Data
  logic                wreq_valid;
  logic                wreq_ready;
  logic [2:0]          wreq_opcode;
  logic [ADDR_W-1:0]   wreq_addr;
  logic [LEN_W-1:0]    wreq_len;
  logic [TAG_W-1:0]    wreq_tag;
  logic                wreq_last;
  logic [DATA_W-1:0]   wdata;
  logic [DATA_W/8-1:0] wstrb;

  // Write Response
  logic                wrsp_valid;
  logic                wrsp_ready;
  logic [TAG_W-1:0]    wrsp_tag;
  logic [3:0]          wrsp_status;

  // 可选信号 tie-off
  assign req_job_id = '0;
  assign req_attr   = '0;

  modport core (
    output req_valid, req_opcode, req_addr, req_len, req_tag, req_job_id, req_attr,
           wreq_valid, wreq_opcode, wreq_addr, wreq_len, wreq_tag, wreq_last, wdata, wstrb,
           rsp_ready, wrsp_ready,
    input  req_ready, rsp_valid, rsp_data, rsp_tag, rsp_last, rsp_status,
           wreq_ready, wrsp_valid, wrsp_tag, wrsp_status
  );

  modport adapter (
    input  req_valid, req_opcode, req_addr, req_len, req_tag, req_job_id, req_attr,
           wreq_valid, wreq_opcode, wreq_addr, wreq_len, wreq_tag, wreq_last, wdata, wstrb,
           rsp_ready, wrsp_ready,
    output req_ready, rsp_valid, rsp_data, rsp_tag, rsp_last, rsp_status,
           wreq_ready, wrsp_valid, wrsp_tag, wrsp_status
  );

  modport monitor (
    input  req_valid, req_ready, req_opcode, req_addr, req_len, req_tag, req_job_id, req_attr,
           rsp_valid, rsp_ready, rsp_data, rsp_tag, rsp_last, rsp_status,
           wreq_valid, wreq_ready, wreq_opcode, wreq_addr, wreq_len, wreq_tag, wreq_last,
           wdata, wstrb, wrsp_valid, wrsp_ready, wrsp_tag, wrsp_status
  );

endinterface : aix_hac_mem_if
