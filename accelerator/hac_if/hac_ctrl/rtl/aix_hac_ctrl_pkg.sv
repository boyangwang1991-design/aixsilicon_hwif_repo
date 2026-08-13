// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_ctrl_pkg: HAC-CTRL 任务控制接口类型（View A）。
// 依赖：aix_common_pkg / aix_hac_if_pkg。

package aix_hac_ctrl_pkg;

  import aix_common_pkg::*;
  import aix_hac_if_pkg::*;

  // 任务命令
  typedef struct packed {
    logic [OPCODE_W-1:0] opcode;
    logic [ADDR_W-1:0]   desc_addr;
    logic [FLAGS_W-1:0]  flags;
  } hac_cmd_t;

  // 任务完成
  typedef struct packed {
    logic [JOB_W-1:0]  job_id;
    logic [15:0]       status;
  } hac_cpl_t;

  // 任务取消
  typedef struct packed {
    logic [JOB_W-1:0] job_id;
  } hac_cancel_t;

  // 控制状态
  typedef struct packed {
    logic busy;
    logic idle;
    logic quiescent;
  } hac_ctrl_status_t;

endpackage : aix_hac_ctrl_pkg
