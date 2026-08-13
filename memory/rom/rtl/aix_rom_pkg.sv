// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_rom_pkg: 只读存储 req/rsp 聚合结构（View A）。
// 信号集对齐 memory/rom/contract/rom.interface.yaml（IFC-ROM-001）。

package aix_rom_pkg;

  localparam int unsigned ROM_ADDR_W = 32;
  localparam int unsigned ROM_DATA_W = 32;

  // 读请求
  typedef struct packed {
    logic [ROM_ADDR_W-1:0] req_addr;
    logic                  req_valid;
    logic                  req_ready;
  } rom_req_t;

  // 读响应
  typedef struct packed {
    logic [ROM_DATA_W-1:0] rsp_data;
    logic                  rsp_valid;
    logic                  rsp_ready;
  } rom_rsp_t;

endpackage : aix_rom_pkg
