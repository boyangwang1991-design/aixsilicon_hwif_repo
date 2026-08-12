// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_memory_1r1w_pkg: 独立读写端口内存接口类型。

package aix_memory_1r1w_pkg;

  localparam int unsigned M1R1W_ADDR_W = 32;
  localparam int unsigned M1R1W_DATA_W = 32;

  // 写端口请求
  typedef struct packed {
    logic                   valid;
    logic [M1R1W_ADDR_W-1:0] waddr;
    logic [M1R1W_DATA_W-1:0] wdata;
    logic [M1R1W_DATA_W/8-1:0] wbe;
  } memory_1r1w_wreq_t;

  // 读端口请求
  typedef struct packed {
    logic                   valid;
    logic [M1R1W_ADDR_W-1:0] raddr;
  } memory_1r1w_rreq_t;

  // 读端口响应
  typedef struct packed {
    logic                   valid;
    logic [M1R1W_DATA_W-1:0] rdata;
  } memory_1r1w_rsp_t;

endpackage : aix_memory_1r1w_pkg
