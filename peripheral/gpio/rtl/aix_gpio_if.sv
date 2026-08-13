// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_gpio_if: GPIO 引脚接口（View B）。
// 信号集对齐 peripheral/gpio/contract/gpio.interface.yaml（IFC-GPIO-001）。
// 双向物理引脚拆分为 *_i / *_o / *_oe_o，避免内部 RTL 直接使用 inout。

interface aix_gpio_if #(
  parameter int unsigned WIDTH = 32
) (
  input logic clk,
  input logic rst_n
);

  logic [WIDTH-1:0] gpio_i;
  logic [WIDTH-1:0] gpio_o;
  logic [WIDTH-1:0] gpio_oe_o;
  logic [WIDTH-1:0] gpio_irq; // capability: interrupt_sideband（可选）

  modport controller (
    input  gpio_i, gpio_irq,
    output gpio_o, gpio_oe_o
  );
  modport endpoint (
    output gpio_i, gpio_irq,
    input  gpio_o, gpio_oe_o
  );

endinterface : aix_gpio_if
