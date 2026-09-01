// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// axi_assign.svh
// AXI 通道 <-> req/rsp 聚合结构 的赋值宏（include file）。
// 参考 PULP AXI 的 axi_assign 宏思路，用于减少重复接线。

`ifndef AIX_AXI_ASSIGN_SVH
`define AIX_AXI_ASSIGN_SVH

  // 从扁平通道信号聚合为 axi_req_t（写侧示例）
  `define AIX_AXI_ASSIGN_TO_REQ(req, AW, W, B) \
    assign (req).awvalid = (AW).awvalid; \
    assign (req).awready = (AW).awready; \
    assign (req).aw      = (AW).aw_chan; \
    assign (req).wvalid  = (W).wvalid;   \
    assign (req).wready  = (W).wready;   \
    assign (req).w       = (W).w_chan;   \
    assign (req).bvalid  = (B).bvalid;   \
    assign (req).bready  = (B).bready;   \
    assign (req).b       = (B).b_chan;

  // 从 axi_req_t 展开为扁平通道信号（写侧示例）
  `define AIX_AXI_ASSIGN_FROM_REQ(req, AW, W, B) \
    assign (AW).awvalid = (req).awvalid; \
    assign (AW).awready = (req).awready; \
    assign (AW).aw_chan = (req).aw;      \
    assign (W).wvalid   = (req).wvalid;  \
    assign (W).wready   = (req).wready;  \
    assign (W).w_chan   = (req).w;       \
    assign (B).bvalid   = (req).bvalid;  \
    assign (B).bready   = (req).bready;  \
    assign (B).b_chan   = (req).b;

`endif
