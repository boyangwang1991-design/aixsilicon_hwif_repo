// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_flat_wrapper: AXI4 扁平端口 Wrapper 模板（View C）。
// 用于 IP 正式交付边界 / Verilog-VHDL 混合 / 工具兼容流程。
//
// 命名遵循：<instance_prefix>_<channel>_<signal>_<direction>
// 示例前缀：s_（target/slave 侧）
//
// 本文件为模板；参数化、可选能力信号（ATOP/USER）的裁剪由 view_generate 工具
// 按 Profile 生成发布态版本。此处展示完整结构。

module aix_axi_flat_wrapper #(
  parameter int unsigned ID_W   = 8,
  parameter int unsigned ADDR_W = 64,
  parameter int unsigned DATA_W = 64,
  parameter int unsigned USER_W = 1
) (
  input  logic              clk_i,
  input  logic              rst_ni,

  // AW channel
  input  logic              s_axi_aw_valid_i,
  output logic              s_axi_aw_ready_o,
  input  logic [ID_W-1:0]   s_axi_aw_id_i,
  input  logic [ADDR_W-1:0] s_axi_aw_addr_i,
  input  logic [7:0]        s_axi_aw_len_i,
  input  logic [2:0]        s_axi_aw_size_i,
  input  logic [1:0]        s_axi_aw_burst_i,
  input  logic              s_axi_aw_lock_i,
  input  logic [3:0]        s_axi_aw_cache_i,
  input  logic [2:0]        s_axi_aw_prot_i,
  input  logic [3:0]        s_axi_aw_qos_i,
  input  logic [3:0]        s_axi_aw_region_i,
  input  logic [5:0]        s_axi_aw_atop_i,
  input  logic [USER_W-1:0] s_axi_aw_user_i,

  // W channel
  input  logic              s_axi_w_valid_i,
  output logic              s_axi_w_ready_o,
  input  logic [DATA_W-1:0] s_axi_w_data_i,
  input  logic [DATA_W/8-1:0] s_axi_w_strb_i,
  input  logic              s_axi_w_last_i,
  input  logic [USER_W-1:0] s_axi_w_user_i,

  // B channel
  output logic              s_axi_b_valid_o,
  input  logic              s_axi_b_ready_i,
  output logic [ID_W-1:0]   s_axi_b_id_o,
  output logic [1:0]        s_axi_b_resp_o,
  output logic [USER_W-1:0] s_axi_b_user_o,

  // AR channel
  input  logic              s_axi_ar_valid_i,
  output logic              s_axi_ar_ready_o,
  input  logic [ID_W-1:0]   s_axi_ar_id_i,
  input  logic [ADDR_W-1:0] s_axi_ar_addr_i,
  input  logic [7:0]        s_axi_ar_len_i,
  input  logic [2:0]        s_axi_ar_size_i,
  input  logic [1:0]        s_axi_ar_burst_i,
  input  logic              s_axi_ar_lock_i,
  input  logic [3:0]        s_axi_ar_cache_i,
  input  logic [2:0]        s_axi_ar_prot_i,
  input  logic [3:0]        s_axi_ar_qos_i,
  input  logic [3:0]        s_axi_ar_region_i,
  input  logic [USER_W-1:0] s_axi_ar_user_i,

  // R channel
  output logic              s_axi_r_valid_o,
  input  logic              s_axi_r_ready_i,
  output logic [ID_W-1:0]   s_axi_r_id_o,
  output logic [DATA_W-1:0] s_axi_r_data_o,
  output logic [1:0]        s_axi_r_resp_o,
  output logic              s_axi_r_last_o,
  output logic [USER_W-1:0] s_axi_r_user_o
);

  // 占位实现：Flat Wrapper 由工具按 YAML 生成接线逻辑。
  // 此模板用于说明端口命名与方向约定（<prefix>_<chan>_<sig>_<dir>）。

  import aix_axi_pkg::*;

  axi_req_t  axi_req;
  axi_rsp_t  axi_rsp;

  // AW 聚合示例（完整接线由生成器产出）
  assign axi_req.aw_valid  = s_axi_aw_valid_i;
  assign s_axi_aw_ready_o  = axi_req.aw_ready;
  assign axi_req.aw.id     = s_axi_aw_id_i;
  assign axi_req.aw.addr   = s_axi_aw_addr_i;
  assign axi_req.aw.len    = s_axi_aw_len_i;
  assign axi_req.aw.size   = s_axi_aw_size_i;
  assign axi_req.aw.burst  = s_axi_aw_burst_i;
  assign axi_req.aw.lock   = s_axi_aw_lock_i;
  assign axi_req.aw.cache  = s_axi_aw_cache_i;
  assign axi_req.aw.prot   = s_axi_aw_prot_i;
  assign axi_req.aw.qos    = s_axi_aw_qos_i;
  assign axi_req.aw.region = s_axi_aw_region_i;
  assign axi_req.aw.atop   = s_axi_aw_atop_i;
  assign axi_req.aw.user   = s_axi_aw_user_i;

  // 其余通道接线由 view_generate 工具生成，此处省略。

endmodule : aix_axi_flat_wrapper
