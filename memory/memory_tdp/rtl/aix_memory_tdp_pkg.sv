// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_memory_tdp_pkg: 真双端口存储 req/rsp 聚合结构（View A）。
// 信号集对齐 memory/memory_tdp/contract/memory_tdp.interface.yaml（IFC-MEM-TDP-001）。

package aix_memory_tdp_pkg;

  localparam int unsigned TDP_ADDR_W = 32;
  localparam int unsigned TDP_DATA_W = 64;

  // 单端口请求/响应
  typedef struct packed {
    logic [TDP_ADDR_W-1:0] addr;
    logic                  we;
    logic [TDP_DATA_W-1:0] wdata;
    logic                  valid;
    logic                  ready;
  } tdp_port_t;

  // A/B 两端口聚合
  typedef struct packed {
    tdp_port_t a;
    tdp_port_t b;
  } memory_tdp_req_t;

  typedef struct packed {
    logic [TDP_DATA_W-1:0] a_rdata;
    logic [TDP_DATA_W-1:0] b_rdata;
  } memory_tdp_rsp_t;

endpackage : aix_memory_tdp_pkg
