// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_noc_flit_if: NoC flit 接口（View B）。
// 信号集对齐 link/noc_flit/contract/noc_flit.interface.yaml（IFC-NOC-001）。
// flit_route / flit_error / flit_poison 为可选能力信号。

interface aix_noc_flit_if #(
  parameter int unsigned FLIT_W = 128,
  parameter int unsigned VC_W   = 2
) (
  input logic clk,
  input logic rst_n
);

  logic                flit_valid;
  logic                flit_ready;
  logic [FLIT_W-1:0]   flit_data;
  logic [1:0]          flit_type;
  logic [VC_W-1:0]     flit_vc;
  logic [7:0]          flit_route; // capability: routing（可选）
  logic                flit_error; // capability: error_sideband（可选）
  logic                flit_poison; // capability: poison（可选）

  modport source (
    output flit_valid, flit_data, flit_type, flit_vc, flit_route, flit_error, flit_poison,
    input  flit_ready
  );
  modport sink (
    input  flit_valid, flit_data, flit_type, flit_vc, flit_route, flit_error, flit_poison,
    output flit_ready
  );

endinterface : aix_noc_flit_if
