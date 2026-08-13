// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_lmem_pkg: HAC-LMEM 本地存储接口类型（View A）。
// 依赖：aix_common_pkg / aix_hac_if_pkg。

package aix_hac_lmem_pkg;

  import aix_common_pkg::*;
  import aix_hac_if_pkg::*;

  // 本地存储请求
  typedef struct packed {
    logic              write;
    logic [BANK_W-1:0] bank;
    logic [ADDR_W-1:0] addr;
    logic [DATA_W-1:0] wdata;
    logic [DATA_W/8-1:0] wstrb;
    logic [TAG_W-1:0]  tag;
  } hac_lmem_req_t;

  // 本地存储响应
  typedef struct packed {
    logic [DATA_W-1:0] rdata;
    logic [TAG_W-1:0]  tag;
    logic              ecc_corrected;
    logic              ecc_uncorrectable;
  } hac_lmem_rsp_t;

  // 宽度参数（由工具按 SSOT 覆盖）
  localparam int unsigned BANK_W = 2;
  localparam int unsigned ADDR_W = 16;
  localparam int unsigned TAG_W  = 4;

endpackage : aix_hac_lmem_pkg
