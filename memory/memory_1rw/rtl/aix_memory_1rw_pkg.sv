// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_memory_1rw_pkg: 单端口内存接口类型。

package aix_memory_1rw_pkg;

  localparam int unsigned M1RW_ADDR_W = 32;
  localparam int unsigned M1RW_DATA_W = 32;

  typedef struct packed {
    logic                  valid;
    logic [M1RW_ADDR_W-1:0] addr;
    logic                  we;
    logic [M1RW_DATA_W-1:0] wdata;
    logic [M1RW_DATA_W/8-1:0] be;
  } memory_1rw_req_t;

  typedef struct packed {
    logic                  valid;
    logic [M1RW_DATA_W-1:0] rdata;
  } memory_1rw_rsp_t;

endpackage : aix_memory_1rw_pkg
