// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_tilelink_ul_if: TileLink-UL 接口（View B）。
// 信号集对齐 bus/tilelink_ul/contract/tilelink_ul.interface.yaml（IFC-TL-UL-001）。
// 统一角色使用 initiator/target。

interface aix_tilelink_ul_if #(
  parameter int unsigned ADDR_W   = 32,
  parameter int unsigned DATA_W   = 64,
  parameter int unsigned SOURCE_W = 4
) (
  input logic clk,
  input logic rst_n
);

  // A 通道
  logic               a_valid;
  logic               a_ready;
  logic [2:0]         a_opcode;
  logic [2:0]         a_param;
  logic [2:0]         a_size;
  logic [SOURCE_W-1:0] a_source;
  logic [ADDR_W-1:0]  a_address;
  logic [DATA_W/8-1:0] a_mask;
  logic [DATA_W-1:0]  a_data;
  // D 通道
  logic               d_valid;
  logic               d_ready;
  logic [1:0]         d_opcode;
  logic [1:0]         d_param;
  logic [2:0]         d_size;
  logic [SOURCE_W-1:0] d_source;
  logic [DATA_W-1:0]  d_data;
  logic               d_error;

  modport initiator (
    output a_valid, a_opcode, a_param, a_size, a_source, a_address, a_mask, a_data,
           d_ready,
    input  a_ready, d_valid, d_opcode, d_param, d_size, d_source, d_data, d_error
  );
  modport target (
    input  a_valid, a_opcode, a_param, a_size, a_source, a_address, a_mask, a_data,
           d_ready,
    output a_ready, d_valid, d_opcode, d_param, d_size, d_source, d_data, d_error
  );

endinterface : aix_tilelink_ul_if
