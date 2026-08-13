// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_ctrl_if: HAC-CTRL 任务控制接口（View B）。
// shell（HAC Shell / 软件控制侧）与 core（HAC Core / 算法侧）连接。

interface aix_hac_ctrl_if #(
  parameter int unsigned JOB_ID_W  = 8,
  parameter int unsigned OPCODE_W  = 8,
  parameter int unsigned ADDR_W    = 64,
  parameter int unsigned FLAGS_W   = 16,
  parameter int unsigned STATUS_W  = 16,
  parameter logic         EN_CANCEL = 1'b1
) (
  input logic clk,
  input logic rst_n
);

  logic                  cmd_valid;
  logic                  cmd_ready;
  logic [JOB_ID_W-1:0]   cmd_job_id;
  logic [OPCODE_W-1:0]   cmd_opcode;
  logic [ADDR_W-1:0]     cmd_desc_addr;
  logic [FLAGS_W-1:0]    cmd_flags;

  logic                  cpl_valid;
  logic                  cpl_ready;
  logic [JOB_ID_W-1:0]   cpl_job_id;
  logic [STATUS_W-1:0]   cpl_status;

  logic                  cancel_valid;
  logic                  cancel_ready;
  logic [JOB_ID_W-1:0]   cancel_job_id;

  logic                  busy;
  logic                  idle;
  logic                  quiescent;

  // 可选信号 tie-off（按规范 clamp）
  assign cancel_valid   = '0;
  assign cancel_job_id  = '0;
  assign cmd_flags      = '0;

  modport shell (
    output cmd_valid, cmd_job_id, cmd_opcode, cmd_desc_addr, cmd_flags,
           cancel_valid, cancel_job_id,
    input  cmd_ready, cpl_valid, cpl_job_id, cpl_status,
           cancel_ready, busy, idle, quiescent
  );

  modport core (
    input  cmd_valid, cmd_job_id, cmd_opcode, cmd_desc_addr, cmd_flags,
           cancel_valid, cancel_job_id,
    output cmd_ready, cpl_valid, cpl_job_id, cpl_status,
           cancel_ready, busy, idle, quiescent
  );

  modport monitor (
    input  cmd_valid, cmd_ready, cmd_job_id, cmd_opcode, cmd_desc_addr, cmd_flags,
           cpl_valid, cpl_ready, cpl_job_id, cpl_status,
           cancel_valid, cancel_ready, cancel_job_id,
           busy, idle, quiescent
  );

endinterface : aix_hac_ctrl_if
