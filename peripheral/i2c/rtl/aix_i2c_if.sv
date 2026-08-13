// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_i2c_if: I2C 引脚接口（View B）。
// 信号集对齐 peripheral/i2c/contract/i2c.interface.yaml（IFC-I2C-001）。
// 开漏线拆分为 *_o / *_oe_o / *_i，由 OE 控制驱动。

interface aix_i2c_if (
  input logic clk,
  input logic rst_n
);

  logic scl_o;
  logic scl_oe_o;
  logic scl_i;
  logic sda_o;
  logic sda_oe_o;
  logic sda_i;

  modport controller (
    output scl_o, scl_oe_o, sda_o, sda_oe_o,
    input  scl_i, sda_i
  );
  modport endpoint (
    input  scl_o, scl_oe_o, sda_o, sda_oe_o,
    output scl_i, sda_i
  );

endinterface : aix_i2c_if
