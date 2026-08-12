// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_reg_native_pkg: 简化寄存器接口 req/rsp 结构（View A）。

package aix_reg_native_pkg;

  import aix_common_pkg::*;

  localparam int unsigned REG_ADDR_W = 32;
  localparam int unsigned REG_DATA_W = 32;

  typedef struct packed {
    logic                  valid;
    logic [REG_ADDR_W-1:0] addr;
    logic [REG_DATA_W-1:0] wdata;
    logic                  we;
    logic [REG_DATA_W/8-1:0] be;
  } reg_req_t;

  typedef struct packed {
    logic                  valid;
    logic [REG_DATA_W-1:0] rdata;
    logic                  err;
  } reg_rsp_t;

  // 简化的 req/rsp 只含数据路径（ready 单独信号）
  typedef struct packed {
    logic [REG_ADDR_W-1:0] addr;
    logic [REG_DATA_W-1:0] wdata;
    logic                  we;
    logic [REG_DATA_W/8-1:0] be;
  } reg_req_payload_t;

  typedef struct packed {
    logic [REG_DATA_W-1:0] rdata;
    logic                  err;
  } reg_rsp_payload_t;

endpackage : aix_reg_native_pkg
