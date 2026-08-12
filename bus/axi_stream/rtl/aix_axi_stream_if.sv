// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_axi_stream_if: AXI-Stream 接口（View B）。

interface aix_axi_stream_if #(
  parameter int unsigned DATA_W = 32,
  parameter int unsigned ID_W   = 8,
  parameter int unsigned DEST_W = 8,
  parameter int unsigned USER_W = 1
) (
  input logic clk,
  input logic rst_n
);

  logic                   tvalid;
  logic                   tready;
  logic [DATA_W-1:0]      tdata;
  logic [DATA_W/8-1:0]    tkeep;
  logic                   tlast;
  logic [USER_W-1:0]      tuser;
  logic [ID_W-1:0]        tid;
  logic [DEST_W-1:0]      tdest;

  modport source (
    output tvalid, tdata, tkeep, tlast, tuser, tid, tdest,
    input  tready
  );
  modport sink (
    input  tvalid, tdata, tkeep, tlast, tuser, tid, tdest,
    output tready
  );
  modport monitor (
    input  tvalid, tready, tdata, tkeep, tlast, tuser, tid, tdest
  );

endinterface : aix_axi_stream_if
