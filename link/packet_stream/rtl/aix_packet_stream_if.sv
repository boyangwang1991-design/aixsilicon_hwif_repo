// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_packet_stream_if: 包流接口（View B）。

interface aix_packet_stream_if #(
  parameter int unsigned DATA_W    = 32,
  parameter int unsigned CHANNEL_W = 4,
  parameter int unsigned USER_W    = 1
) (
  input logic clk,
  input logic rst_n
);

  logic                     valid;
  logic                     ready;
  logic [DATA_W-1:0]        data;
  logic                     sop;
  logic                     eop;
  logic [DATA_W/8-1:0]      byte_enable;
  logic [CHANNEL_W-1:0]     channel;
  logic                     error;
  logic [USER_W-1:0]        user;

  modport source (
    output valid, data, sop, eop, byte_enable, channel, error, user,
    input  ready
  );
  modport sink (
    input  valid, data, sop, eop, byte_enable, channel, error, user,
    output ready
  );

endinterface : aix_packet_stream_if
