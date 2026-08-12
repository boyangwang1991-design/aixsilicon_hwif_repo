// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_assign.svh
// AXI 通道 <-> req/rsp 聚合结构 的赋值宏（include file）。
// 参考 PULP AXI 的 axi_assign 宏思路，用于减少重复接线。

`ifndef AIX_AXI_ASSIGN_SVH
`define AIX_AXI_ASSIGN_SVH

  // 从扁平通道信号聚合为 axi_req_t（写侧示例）
  `define AIX_AXI_ASSIGN_TO_REQ(req, AW, W, B) \
    assign (req).aw_valid = (AW).aw_valid; \
    assign (req).aw_ready = (AW).aw_ready; \
    assign (req).aw       = (AW).aw_chan;  \
    assign (req).w_valid  = (W).w_valid;   \
    assign (req).w_ready  = (W).w_ready;   \
    assign (req).w        = (W).w_chan;    \
    assign (req).b_valid  = (B).b_valid;   \
    assign (req).b_ready  = (B).b_ready;   \
    assign (req).b        = (B).b_chan;

  // 从 axi_req_t 展开为扁平通道信号（写侧示例）
  `define AIX_AXI_ASSIGN_FROM_REQ(req, AW, W, B) \
    assign (AW).aw_valid = (req).aw_valid; \
    assign (AW).aw_ready = (req).aw_ready; \
    assign (AW).aw_chan  = (req).aw;       \
    assign (W).w_valid   = (req).w_valid;  \
    assign (W).w_ready   = (req).w_ready;  \
    assign (W).w_chan    = (req).w;        \
    assign (B).b_valid   = (req).b_valid;  \
    assign (B).b_ready   = (req).b_ready;  \
    assign (B).b_chan    = (req).b;

`endif
