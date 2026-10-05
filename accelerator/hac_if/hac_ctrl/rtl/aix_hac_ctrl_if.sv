// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_ctrl_if: 由 tools/view_generate/view_generate.py 从 YAML Contract 确定性生成。
// 契约来源：IFC-HAC_CTRL-001。禁止手工修改，改契约后重新生成。

interface aix_hac_ctrl_if#(
  parameter int unsigned JOB_ID_W = 8,
  parameter int unsigned OPCODE_W = 8,
  parameter int unsigned ADDR_W = 64,
  parameter int unsigned FLAGS_W = 16,
  parameter int unsigned STATUS_W = 16,
  parameter int unsigned CFG_SLOT_W = 1,
  parameter int unsigned PARAM_VERSION_W = 16,
  parameter int unsigned PARAM_LEN_W = 32,
  parameter int unsigned MAX_INFLIGHT = 1
) (
  input  logic clk,
  input  logic rst_n
);

  logic cfg_commit_valid; // channel=cfg_commit
  logic cfg_commit_ready; // channel=cfg_commit
  logic [JOB_ID_W-1:0] cfg_commit_job_id; // channel=cfg_commit
  logic [CFG_SLOT_W-1:0] cfg_commit_slot; // channel=cfg_commit
  logic cfg_rsp_valid; // channel=cfg_response
  logic cfg_rsp_ready; // channel=cfg_response
  logic [JOB_ID_W-1:0] cfg_rsp_job_id; // channel=cfg_response
  logic [CFG_SLOT_W-1:0] cfg_rsp_slot; // channel=cfg_response
  logic [STATUS_W-1:0] cfg_rsp_status; // channel=cfg_response
  logic cmd_valid; // channel=cmd
  logic cmd_ready; // channel=cmd
  logic [JOB_ID_W-1:0] cmd_job_id; // channel=cmd
  logic [OPCODE_W-1:0] cmd_opcode; // channel=cmd
  logic [CFG_SLOT_W-1:0] cmd_cfg_slot; // channel=cmd
  logic [ADDR_W-1:0] cmd_desc_addr; // channel=cmd
  logic [PARAM_VERSION_W-1:0] cmd_param_version; // channel=cmd
  logic [PARAM_LEN_W-1:0] cmd_param_bytes; // channel=cmd
  logic [FLAGS_W-1:0] cmd_flags; // channel=cmd
  logic cpl_valid; // channel=cpl
  logic cpl_ready; // channel=cpl
  logic [JOB_ID_W-1:0] cpl_job_id; // channel=cpl
  logic [STATUS_W-1:0] cpl_status; // channel=cpl
  logic cancel_valid; // channel=cancel
  logic cancel_ready; // channel=cancel
  logic [JOB_ID_W-1:0] cancel_job_id; // channel=cancel
  logic busy; // channel=status
  logic idle; // channel=status
  logic quiescent; // channel=status

  modport shell (
    output cfg_commit_valid , cfg_commit_job_id , cfg_commit_slot , cfg_rsp_ready , cmd_valid , cmd_job_id , cmd_opcode , cmd_cfg_slot , cmd_desc_addr , cmd_param_version , cmd_param_bytes , cmd_flags , cpl_ready , cancel_valid , cancel_job_id,
    input  cfg_commit_ready , cfg_rsp_valid , cfg_rsp_job_id , cfg_rsp_slot , cfg_rsp_status , cmd_ready , cpl_valid , cpl_job_id , cpl_status , cancel_ready , busy , idle , quiescent
  );

  modport core (
    output cfg_commit_ready , cfg_rsp_valid , cfg_rsp_job_id , cfg_rsp_slot , cfg_rsp_status , cmd_ready , cpl_valid , cpl_job_id , cpl_status , cancel_ready , busy , idle , quiescent,
    input  cfg_commit_valid , cfg_commit_job_id , cfg_commit_slot , cfg_rsp_ready , cmd_valid , cmd_job_id , cmd_opcode , cmd_cfg_slot , cmd_desc_addr , cmd_param_version , cmd_param_bytes , cmd_flags , cpl_ready , cancel_valid , cancel_job_id
  );

endinterface : aix_hac_ctrl_if
