// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_packet_stream_pkg: 包流接口类型。

package aix_packet_stream_pkg;

  localparam int unsigned PS_DATA_W    = 32;
  localparam int unsigned PS_CHANNEL_W = 4;
  localparam int unsigned PS_USER_W    = 1;

  typedef struct packed {
    logic                    valid;
    logic [PS_DATA_W-1:0]    data;
    logic                    sop;
    logic                    eop;
    logic [PS_DATA_W/8-1:0]  byte_enable;  // capability: byte_enable
    logic [PS_CHANNEL_W-1:0] channel;      // capability: channel
    logic                    error;        // capability: error_sideband
    logic [PS_USER_W-1:0]    user;         // capability: user_sideband
  } packet_stream_req_t;

  typedef struct packed {
    logic ready;
  } packet_stream_rsp_t;

endpackage : aix_packet_stream_pkg
