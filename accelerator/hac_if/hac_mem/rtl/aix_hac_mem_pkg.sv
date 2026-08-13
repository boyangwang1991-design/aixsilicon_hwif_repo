// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_mem_pkg: HAC-MEM 系统访存接口类型（View A）。
// 依赖：aix_common_pkg / aix_hac_if_pkg。

package aix_hac_mem_pkg;

  import aix_common_pkg::*;
  import aix_hac_if_pkg::*;

  // 访存请求
  typedef struct packed {
    hac_mem_opcode_t opcode;
    logic [ADDR_W-1:0] addr;
    logic [LEN_W-1:0]  len_bytes;
    logic [TAG_W-1:0]  tag;
    logic [JOB_W-1:0]  job_id;
    logic [ATTR_W-1:0] attr;
  } hac_mem_req_t;

  // 读响应
  typedef struct packed {
    logic [DATA_W-1:0] data;
    logic [TAG_W-1:0]  tag;
    logic              last;
    hac_mem_status_t   status;
  } hac_mem_rd_rsp_t;

  // 写请求（含数据）
  typedef struct packed {
    hac_mem_opcode_t opcode;
    logic [ADDR_W-1:0] addr;
    logic [LEN_W-1:0]  len_bytes;
    logic [TAG_W-1:0]  tag;
    logic              last;
    logic [DATA_W-1:0] data;
    logic [DATA_W/8-1:0] strb;
  } hac_mem_wr_req_t;

  // 写响应
  typedef struct packed {
    logic [TAG_W-1:0]  tag;
    hac_mem_status_t   status;
  } hac_mem_wr_rsp_t;

endpackage : aix_hac_mem_pkg
