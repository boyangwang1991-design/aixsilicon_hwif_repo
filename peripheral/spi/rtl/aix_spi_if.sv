// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_spi_if: SPI 引脚接口（View B）。
// 信号集对齐 peripheral/spi/contract/spi.interface.yaml（IFC-SPI-001）。
// quad_mode（io[3:0]）为可选能力；双向数据线拆分为 *_i / *_o / *_oe_o。

interface aix_spi_if #(
  parameter int unsigned CS_W = 1
) (
  input logic clk,
  input logic rst_n
);

  logic sclk;
  logic [CS_W-1:0] cs;
  logic mosi;
  logic miso;
  // capability: quad_mode（可选）
  logic [3:0] io_i;
  logic [3:0] io_o;
  logic [3:0] io_oe_o;

  modport controller (
    output sclk, cs, mosi, io_o, io_oe_o,
    input  miso, io_i
  );
  modport endpoint (
    input  sclk, cs, mosi, io_o, io_oe_o,
    output miso, io_i
  );

endinterface : aix_spi_if
