// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_credit_link_if: 信用链路接口（View B）。

interface aix_credit_link_if #(
  parameter int unsigned FLIT_W   = 128,
  parameter int unsigned VC_W     = 2,
  parameter int unsigned CREDIT_W = 4
) (
  input logic clk,
  input logic rst_n
);

  logic                    flit_valid;
  logic                    flit_ready;
  logic [FLIT_W-1:0]       flit_data;
  logic [VC_W-1:0]         flit_vc;
  logic [3:0]              flit_qos;
  logic                    flit_retry;
  logic                    credit_valid;
  logic [CREDIT_W-1:0]     credit_return;

  modport initiator (
    output flit_valid, flit_data, flit_vc, flit_qos, flit_retry,
    input  flit_ready, credit_valid, credit_return
  );
  modport target (
    input  flit_valid, flit_data, flit_vc, flit_qos, flit_retry,
    output flit_ready, credit_valid, credit_return
  );

endinterface : aix_credit_link_if
