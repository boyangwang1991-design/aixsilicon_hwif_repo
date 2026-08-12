// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// apb_target_example: 消费 aix:interface:apb 的最小 target 示例（骨架）。
// 使用 View A（packed struct apb_req_t / apb_rsp_t）。

module apb_target_example #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input  logic                    clk_i,
  input  logic                    rst_ni,
  input  logic                    psel_i,
  input  logic                    penable_i,
  input  logic [ADDR_W-1:0]       paddr_i,
  input  logic                    pwrite_i,
  input  logic [DATA_W-1:0]       pwdata_i,
  output logic [DATA_W-1:0]       prdata_o,
  output logic                    pready_o,
  output logic                    pslverr_o
);

  import aix_apb_pkg::*;

  apb_req_t req;
  apb_rsp_t rsp;

  assign req.psel    = psel_i;
  assign req.penable = penable_i;
  assign req.paddr   = paddr_i;
  assign req.pwrite  = pwrite_i;
  assign req.pwdata  = pwdata_i;
  assign req.pstrb   = '1;
  assign req.pprot   = '0;

  // 示例寄存器
  logic [DATA_W-1:0] reg0_q;
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      reg0_q <= '0;
    end else if (req.pwrite && rsp.pready) begin
      reg0_q <= req.pwdata;
    end
  end

  assign rsp.pready  = 1'b1;
  assign rsp.prdata  = req.pwrite ? '0 : reg0_q;
  assign rsp.pslverr = 1'b0;

  assign pready_o  = rsp.pready;
  assign prdata_o  = rsp.prdata;
  assign pslverr_o = rsp.pslverr;

endmodule : apb_target_example
