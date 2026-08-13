// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_obi_pkg: RISC-V OBI req/rsp 聚合结构（View A）。
// 参考 PULP OBI（reference/obi）的 a_chan_t / r_chan_t 聚合方式，
// 命名与信号集对齐 bus/obi/contract/obi.interface.yaml（IFC-OBI-001）。

package aix_obi_pkg;

  localparam int unsigned OBI_ADDR_W = 32;
  localparam int unsigned OBI_DATA_W = 32;

  // Request channel：地址/写数据/写使能/字节使能聚合
  typedef struct packed {
    logic [OBI_ADDR_W-1:0]  addr;
    logic                   we;
    logic [OBI_DATA_W/8-1:0] be;
    logic [OBI_DATA_W-1:0]  wdata;
  } obi_a_chan_t;

  // Response channel：读数据/错误聚合
  typedef struct packed {
    logic [OBI_DATA_W-1:0] rdata;
    logic                  err;
  } obi_r_chan_t;

  // Request 聚合（valid/ready 独立信号）
  typedef struct packed {
    obi_a_chan_t a;
    logic        req_valid;
    logic        req_ready;
  } obi_req_t;

  // Response 聚合（valid/ready 独立信号）
  typedef struct packed {
    obi_r_chan_t r;
    logic        rsp_valid;
    logic        rsp_ready;
  } obi_rsp_t;

endpackage : aix_obi_pkg
