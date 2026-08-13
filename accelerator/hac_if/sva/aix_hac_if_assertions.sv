// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_if_assertions: HAC-IF 基线断言（协议 SVA 归 VIP Repo，此处为接口层不变量骨架）。
// 依赖：aix_common_pkg / aix_hac_if_pkg。

`ifndef AIX_HAC_IF_ASSERTIONS_SV
`define AIX_HAC_IF_ASSERTIONS_SV

module aix_hac_if_assertions
  import aix_hac_if_pkg::*;
(
  input logic clk,
  input logic rst_n,

  // HAC-CTRL
  input logic        ctrl_cmd_valid,
  input logic        ctrl_cmd_ready,
  input logic [7:0]  ctrl_cmd_job_id,
  input logic        ctrl_cpl_valid,
  input logic        ctrl_cpl_ready,
  input logic [7:0]  ctrl_cpl_job_id,
  input logic        ctrl_quiescent,

  // HAC-MEM
  input logic               mem_req_valid,
  input logic               mem_req_ready,
  input logic [5:0]         mem_req_tag,
  input logic               mem_rsp_valid,
  input logic               mem_rsp_ready,
  input logic [5:0]         mem_rsp_tag
);

  // 背压期间命令 Payload 稳定（job_id 必须保持）
  property p_ctrl_cmd_stable;
    @(posedge clk) disable iff (!rst_n)
      (ctrl_cmd_valid && !ctrl_cmd_ready) |=> ($stable(ctrl_cmd_job_id) || ctrl_cmd_ready);
  endproperty

  // 背压期间完成 Payload 稳定
  property p_ctrl_cpl_stable;
    @(posedge clk) disable iff (!rst_n)
      (ctrl_cpl_valid && !ctrl_cpl_ready) |=> ($stable(ctrl_cpl_job_id) || ctrl_cpl_ready);
  endproperty

  // quiescent 时不允许有在途访存（示例简化：quiescent 时无 mem 请求在途）
  property p_quiescent_no_mem_outstanding;
    @(posedge clk) disable iff (!rst_n)
      ctrl_quiescent |-> !mem_req_valid;
  endproperty

  // Tag 不提前复用（覆盖更复杂集合逻辑由 VIP 实现；此处给出握手不变量）
  property p_mem_rsp_tag_match;
    @(posedge clk) disable iff (!rst_n)
      (mem_rsp_valid && !mem_rsp_ready) |=> ($stable(mem_rsp_tag) || mem_rsp_ready);
  endproperty

  A_CTRL_CMD_STABLE   : assert property (p_ctrl_cmd_stable);
  A_CTRL_CPL_STABLE   : assert property (p_ctrl_cpl_stable);
  A_QUIESCENT_NO_MEM  : assert property (p_quiescent_no_mem_outstanding);
  A_MEM_RSP_TAG_MATCH : assert property (p_mem_rsp_tag_match);

endmodule : aix_hac_if_assertions

`endif
