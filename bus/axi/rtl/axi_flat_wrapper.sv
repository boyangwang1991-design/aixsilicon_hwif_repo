// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// axi_flat_wrapper: AXI4 扁平端口 Wrapper 模板（View C）。
// 用于 IP 正式交付边界 / Verilog-VHDL 混合 / 工具兼容流程。
//
// 命名遵循：<instance_prefix>_<channel>_<signal>_<direction>
// 示例前缀：s_（target/slave 侧）
//
// 本文件为模板；参数化、可选能力信号（ATOP/USER）的裁剪由 view_generate 工具
// 按 Profile 生成发布态版本。此处展示完整结构。

module axi_flat_wrapper #(
  parameter int unsigned ID_W   = 8,
  parameter int unsigned ADDR_W = 64,
  parameter int unsigned DATA_W = 64,
  parameter int unsigned USER_W = 1
) (
  input  logic              clk_i,
  input  logic              rst_ni,

  // AW channel
  input  logic              s_axi_awvalid_i,
  output logic              s_axi_awready_o,
  input  logic [ID_W-1:0]   s_axi_awid_i,
  input  logic [ADDR_W-1:0] s_axi_awaddr_i,
  input  logic [7:0]        s_axi_awlen_i,
  input  logic [2:0]        s_axi_awsize_i,
  input  logic [1:0]        s_axi_awburst_i,
  input  logic              s_axi_awlock_i,
  input  logic [3:0]        s_axi_awcache_i,
  input  logic [2:0]        s_axi_awprot_i,
  input  logic [3:0]        s_axi_awqos_i,
  input  logic [3:0]        s_axi_awregion_i,
  input  logic [5:0]        s_axi_awatop_i,
  input  logic [USER_W-1:0] s_axi_awuser_i,

  // W channel
  input  logic              s_axi_wvalid_i,
  output logic              s_axi_wready_o,
  input  logic [DATA_W-1:0] s_axi_wdata_i,
  input  logic [DATA_W/8-1:0] s_axi_wstrb_i,
  input  logic              s_axi_wlast_i,
  input  logic [USER_W-1:0] s_axi_wuser_i,

  // B channel
  output logic              s_axi_bvalid_o,
  input  logic              s_axi_bready_i,
  output logic [ID_W-1:0]   s_axi_bid_o,
  output logic [1:0]        s_axi_bresp_o,
  output logic [USER_W-1:0] s_axi_buser_o,

  // AR channel
  input  logic              s_axi_arvalid_i,
  output logic              s_axi_arready_o,
  input  logic [ID_W-1:0]   s_axi_arid_i,
  input  logic [ADDR_W-1:0] s_axi_araddr_i,
  input  logic [7:0]        s_axi_arlen_i,
  input  logic [2:0]        s_axi_arsize_i,
  input  logic [1:0]        s_axi_arburst_i,
  input  logic              s_axi_arlock_i,
  input  logic [3:0]        s_axi_arcache_i,
  input  logic [2:0]        s_axi_arprot_i,
  input  logic [3:0]        s_axi_arqos_i,
  input  logic [3:0]        s_axi_arregion_i,
  input  logic [USER_W-1:0] s_axi_aruser_i,

  // R channel
  output logic              s_axi_rvalid_o,
  input  logic              s_axi_rready_i,
  output logic [ID_W-1:0]   s_axi_rid_o,
  output logic [DATA_W-1:0] s_axi_rdata_o,
  output logic [1:0]        s_axi_rresp_o,
  output logic              s_axi_rlast_o,
  output logic [USER_W-1:0] s_axi_ruser_o
);

  // 占位实现：Flat Wrapper 由工具按 YAML 生成接线逻辑。
  // 此模板用于说明端口命名与方向约定（<prefix>_<chan>_<sig>_<dir>）。

  import axi_pkg::*;

  axi_req_t  axi_req;
  axi_rsp_t  axi_rsp;

  // AW 聚合示例（完整接线由生成器产出）
  assign axi_req.awvalid  = s_axi_awvalid_i;
  assign s_axi_awready_o  = axi_req.awready;
  assign axi_req.aw.id    = s_axi_awid_i;
  assign axi_req.aw.addr  = s_axi_awaddr_i;
  assign axi_req.aw.len   = s_axi_awlen_i;
  assign axi_req.aw.size  = s_axi_awsize_i;
  assign axi_req.aw.burst = s_axi_awburst_i;
  assign axi_req.aw.lock  = s_axi_awlock_i;
  assign axi_req.aw.cache = s_axi_awcache_i;
  assign axi_req.aw.prot  = s_axi_awprot_i;
  assign axi_req.aw.qos   = s_axi_awqos_i;
  assign axi_req.aw.region = s_axi_awregion_i;
  assign axi_req.aw.atop  = s_axi_awatop_i;
  assign axi_req.aw.user  = s_axi_awuser_i;

  // 其余通道接线由 view_generate 工具生成，此处省略。

endmodule : axi_flat_wrapper
