// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_tilelink_ul_pkg: TileLink-UL req/rsp 聚合结构（View A）。
// 信号集对齐 bus/tilelink_ul/contract/tilelink_ul.interface.yaml（IFC-TL-UL-001）。

package aix_tilelink_ul_pkg;

  localparam int unsigned TLUL_ADDR_W   = 32;
  localparam int unsigned TLUL_DATA_W   = 64;
  localparam int unsigned TLUL_SOURCE_W = 4;

  // A 通道（initiator -> target）
  typedef struct packed {
    logic [2:0]                a_opcode;
    logic [2:0]                a_param;
    logic [2:0]                a_size;
    logic [TLUL_SOURCE_W-1:0]  a_source;
    logic [TLUL_ADDR_W-1:0]    a_address;
    logic [TLUL_DATA_W/8-1:0]  a_mask;
    logic [TLUL_DATA_W-1:0]    a_data;
  } tlul_a_chan_t;

  // D 通道（target -> initiator）
  typedef struct packed {
    logic [1:0]                d_opcode;
    logic [1:0]                d_param;
    logic [2:0]                d_size;
    logic [TLUL_SOURCE_W-1:0]  d_source;
    logic [TLUL_DATA_W-1:0]    d_data;
    logic                      d_error;
  } tlul_d_chan_t;

  // 聚合（valid/ready 独立）
  typedef struct packed {
    tlul_a_chan_t a;
    logic         a_valid;
    logic         a_ready;
  } tilelink_ul_req_t;

  typedef struct packed {
    tlul_d_chan_t d;
    logic         d_valid;
    logic         d_ready;
  } tilelink_ul_rsp_t;

endpackage : aix_tilelink_ul_pkg
