// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_mem_if: 由 tools/view_generate/view_generate.py 从 YAML Contract 确定性生成。
// 契约来源：IFC-HAC_MEM-001。禁止手工修改，改契约后重新生成。

interface aix_hac_mem_if#(
  parameter int unsigned ADDR_W = 64,
  parameter int unsigned DATA_W = 128,
  parameter int unsigned LEN_W = 32,
  parameter int unsigned TAG_W = 6,
  parameter int unsigned JOB_ID_W = 8,
  parameter int unsigned ATTR_W = 8,
  parameter int unsigned MAX_OUTSTANDING = 1
) (
  input  logic clk,
  input  logic rst_n
);

  logic req_valid; // channel=read_req
  logic req_ready; // channel=read_req
  logic [ADDR_W-1:0] req_addr; // channel=read_req
  logic [LEN_W-1:0] req_len_bytes; // channel=read_req
  logic [TAG_W-1:0] req_tag; // channel=read_req
  logic [JOB_ID_W-1:0] req_job_id; // channel=read_req
  logic [ATTR_W-1:0] req_attr; // channel=read_req
  logic rsp_valid; // channel=read_rsp
  logic rsp_ready; // channel=read_rsp
  logic [DATA_W-1:0] rsp_data; // channel=read_rsp
  logic [TAG_W-1:0] rsp_tag; // channel=read_rsp
  logic rsp_last; // channel=read_rsp
  logic [3:0] rsp_status; // channel=read_rsp
  logic wreq_valid; // channel=write_req
  logic wreq_ready; // channel=write_req
  logic [ADDR_W-1:0] wreq_addr; // channel=write_req
  logic [LEN_W-1:0] wreq_len_bytes; // channel=write_req
  logic [TAG_W-1:0] wreq_tag; // channel=write_req
  logic [JOB_ID_W-1:0] wreq_job_id; // channel=write_req
  logic [ATTR_W-1:0] wreq_attr; // channel=write_req
  logic wdata_valid; // channel=write_data
  logic wdata_ready; // channel=write_data
  logic [DATA_W-1:0] wdata; // channel=write_data
  logic [DATA_W/8-1:0] wstrb; // channel=write_data
  logic [TAG_W-1:0] wdata_tag; // channel=write_data
  logic wdata_last; // channel=write_data
  logic wrsp_valid; // channel=write_rsp
  logic wrsp_ready; // channel=write_rsp
  logic [TAG_W-1:0] wrsp_tag; // channel=write_rsp
  logic [3:0] wrsp_status; // channel=write_rsp

  modport core (
    output req_valid , req_addr , req_len_bytes , req_tag , req_job_id , req_attr , rsp_ready , wreq_valid , wreq_addr , wreq_len_bytes , wreq_tag , wreq_job_id , wreq_attr , wdata_valid , wdata , wstrb , wdata_tag , wdata_last , wrsp_ready,
    input  req_ready , rsp_valid , rsp_data , rsp_tag , rsp_last , rsp_status , wreq_ready , wdata_ready , wrsp_valid , wrsp_tag , wrsp_status
  );

  modport adapter (
    output req_ready , rsp_valid , rsp_data , rsp_tag , rsp_last , rsp_status , wreq_ready , wdata_ready , wrsp_valid , wrsp_tag , wrsp_status,
    input  req_valid , req_addr , req_len_bytes , req_tag , req_job_id , req_attr , rsp_ready , wreq_valid , wreq_addr , wreq_len_bytes , wreq_tag , wreq_job_id , wreq_attr , wdata_valid , wdata , wstrb , wdata_tag , wdata_last , wrsp_ready
  );

endinterface : aix_hac_mem_if
