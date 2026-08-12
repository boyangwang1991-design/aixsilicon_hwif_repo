// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_typedef.svh
// AXI 通道 typedef 宏（include file），供不 import package 的代码使用。
// 新代码应优先 import aix_axi_pkg::*。
// 本文件由工具对照 aix_axi_pkg / YAML 进行一致性检查。

`ifndef AIX_AXI_TYPEDEF_SVH
`define AIX_AXI_TYPEDEF_SVH

  `include "aix_common_typedef.svh"

  // 通道 typedef（与 aix_axi_pkg 保持一致）
  typedef struct packed {
    logic [ 8-1:0]     id;
    logic [64-1:0]     addr;
    logic [ 8-1:0]     len;
    logic [ 3-1:0]     size;
    logic [ 2-1:0]     burst;
    logic              lock;
    logic [ 4-1:0]     cache;
    logic [ 3-1:0]     prot;
    logic [ 4-1:0]     qos;
    logic [ 4-1:0]     region;
    logic [ 6-1:0]     atop;
    logic [ 1-1:0]     user;
  } aix_axi_aw_chan_t;

  typedef struct packed {
    logic [64-1:0]     data;
    logic [ 8-1:0]     strb;
    logic              last;
    logic [ 1-1:0]     user;
  } aix_axi_w_chan_t;

  typedef struct packed {
    logic [ 8-1:0]     id;
    logic [ 2-1:0]     resp;
    logic [ 1-1:0]     user;
  } aix_axi_b_chan_t;

  typedef struct packed {
    logic [ 8-1:0]     id;
    logic [64-1:0]     addr;
    logic [ 8-1:0]     len;
    logic [ 3-1:0]     size;
    logic [ 2-1:0]     burst;
    logic              lock;
    logic [ 4-1:0]     cache;
    logic [ 3-1:0]     prot;
    logic [ 4-1:0]     qos;
    logic [ 4-1:0]     region;
    logic [ 1-1:0]     user;
  } aix_axi_ar_chan_t;

  typedef struct packed {
    logic [ 8-1:0]     id;
    logic [64-1:0]     data;
    logic [ 2-1:0]     resp;
    logic              last;
    logic [ 1-1:0]     user;
  } aix_axi_r_chan_t;

`endif
