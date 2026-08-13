// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_rom_if: 只读存储接口（View B）。
// 信号集对齐 memory/rom/contract/rom.interface.yaml（IFC-ROM-001）。

interface aix_rom_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic              req_valid;
  logic              req_ready;
  logic [ADDR_W-1:0] req_addr;
  logic              rsp_valid;
  logic              rsp_ready;
  logic [DATA_W-1:0] rsp_data;

  modport requester (
    output req_valid, req_addr, rsp_ready,
    input  req_ready, rsp_valid, rsp_data
  );
  modport memory (
    input  req_valid, req_addr, rsp_ready,
    output req_ready, rsp_valid, rsp_data
  );

endinterface : aix_rom_if
