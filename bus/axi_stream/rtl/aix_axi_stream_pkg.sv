// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_stream_pkg: AXI-Stream req/rsp 结构（View A）。

package aix_axi_stream_pkg;

  import aix_common_pkg::*;

  localparam int unsigned AXIS_DATA_W = 32;
  localparam int unsigned AXIS_ID_W   = 8;
  localparam int unsigned AXIS_DEST_W = 8;
  localparam int unsigned AXIS_USER_W = 1;

  // Stream request（source -> sink）
  typedef struct packed {
    logic                   tvalid;
    logic [AXIS_DATA_W-1:0] tdata;
    logic [AXIS_DATA_W/8-1:0] tkeep;   // capability: byte_keep
    logic                   tlast;     // capability: packet_boundary
    logic [AXIS_USER_W-1:0] tuser;     // capability: user_sideband
    logic [AXIS_ID_W-1:0]   tid;       // capability: stream_id
    logic [AXIS_DEST_W-1:0] tdest;     // capability: stream_id
  } axi_stream_req_t;

  // Stream response（sink -> source，仅含 ready）
  typedef struct packed {
    logic tready;
  } axi_stream_rsp_t;

endpackage : aix_axi_stream_pkg
