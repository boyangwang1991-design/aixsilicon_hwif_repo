// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_interrupt_if: 中断接口（View B）。
// source 产生中断；receiver 消费并可应答（可选）。

interface aix_interrupt_if #(
  parameter int unsigned WIDTH = 1,
  parameter logic         EN_ACK = 1'b0
) (
  input logic clk,
  input logic rst_n
);

  logic [WIDTH-1:0] irq;
  logic [WIDTH-1:0] irq_ack;

  assign irq_ack = '0;

  modport source   (output irq, input  irq_ack);
  modport receiver (input  irq, output irq_ack);

endinterface : aix_interrupt_if
