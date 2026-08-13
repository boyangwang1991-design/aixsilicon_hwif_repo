// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_if_pkg: HAC-IF 公共类型包（View A）。
// - HAC-IF 版本与能力描述
// - 通用任务/访存/事件类型
// - 状态码常量
// 依赖：aix_common_pkg。

package aix_hac_if_pkg;

  import aix_common_pkg::*;

  // ---------------------------------------------------------------------
  // 版本
  // ---------------------------------------------------------------------
  localparam string HAC_IF_VERSION = "1.0";
  localparam int unsigned HAC_IF_MAJOR = 1;
  localparam int unsigned HAC_IF_MINOR = 0;

  // ---------------------------------------------------------------------
  // 能力位（capability bitmap）
  // ---------------------------------------------------------------------
  typedef struct packed {
    logic multi_job;
    logic mem_out_of_order;
    logic unaligned_access;
    logic stream_packet;
    logic soft_reset;
    logic drain;
    logic clock_gating;
    logic retention;
    logic isolation;
  } hac_capability_t;

  // ---------------------------------------------------------------------
  // HAC-CTRL 类型
  // ---------------------------------------------------------------------
  typedef enum logic [2:0] {
    HAC_STATUS_OK    = 3'd0,
    HAC_STATUS_ERR   = 3'd1,
    HAC_STATUS_ABORT = 3'd2,
    HAC_STATUS_TIMEOUT = 3'd3
  } hac_cpl_status_t;

  // ---------------------------------------------------------------------
  // HAC-MEM 类型（抽象 Request/Response）
  // ---------------------------------------------------------------------
  typedef enum logic [2:0] {
    HAC_MEM_READ    = 3'd0,
    HAC_MEM_WRITE   = 3'd1,
    HAC_MEM_PREFETCH= 3'd2,
    HAC_MEM_ATOMIC  = 3'd3
  } hac_mem_opcode_t;

  // 与 aix_common_pkg::err_t 对齐的响应状态
  typedef enum logic [3:0] {
    HAC_RSP_OK      = 4'h0,
    HAC_RSP_DECERR  = 4'h1,
    HAC_RSP_SLVERR  = 4'h2,
    HAC_RSP_PARERR  = 4'h3,
    HAC_RSP_SECERR  = 4'h4,
    HAC_RSP_TIMEOUT = 4'h5
  } hac_mem_status_t;

  typedef struct packed {
    hac_mem_opcode_t opcode;
    logic [ADDR_W-1:0] addr;
    logic [LEN_W-1:0]  len_bytes;
    logic [TAG_W-1:0]  tag;
    logic [JOB_W-1:0]  job_id;
    logic [ATTR_W-1:0] attr;
  } hac_mem_req_t;

  typedef struct packed {
    logic [DATA_W-1:0] data;
    logic [TAG_W-1:0]  tag;
    logic              last;
    hac_mem_status_t   status;
  } hac_mem_rsp_t;

  // 参数化宽度（由工具按 SSOT 覆盖）
  localparam int unsigned ADDR_W = 64;
  localparam int unsigned LEN_W  = 16;
  localparam int unsigned TAG_W  = 6;
  localparam int unsigned JOB_W  = 8;
  localparam int unsigned ATTR_W = 8;
  localparam int unsigned DATA_W = 128;
  localparam int unsigned STAT_W = 8;

  // ---------------------------------------------------------------------
  // HAC-EVENT 类型
  // ---------------------------------------------------------------------
  typedef enum logic [2:0] {
    HAC_EVT_COMPLETION,
    HAC_EVT_RECOVERABLE,
    HAC_EVT_FATAL,
    HAC_EVT_PERFORMANCE,
    HAC_EVT_SECURITY,
    HAC_EVT_DEBUG
  } hac_event_type_t;

  typedef enum logic [1:0] {
    HAC_SEV_INFO,
    HAC_SEV_WARNING,
    HAC_SEV_FATAL
  } hac_severity_t;

  typedef struct packed {
    hac_event_type_t event_type;
    hac_severity_t   severity;
    logic [ID_W-1:0] source;
    logic [JOB_W-1:0] job_id;
    logic [15:0]     code;
    logic [31:0]     info;
  } hac_event_t;

  // ---------------------------------------------------------------------
  // 辅助函数
  // ---------------------------------------------------------------------
  // 从状态码分区判断是否属于错误
  function automatic logic hac_status_is_error(input logic [15:0] status);
    return (status[15:8] == 8'h00) ? 1'b0 : 1'b1;
  endfunction

endpackage : aix_hac_if_pkg
