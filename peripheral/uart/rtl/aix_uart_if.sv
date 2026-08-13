// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_uart_if: UART 引脚接口（View B）。
// 信号集对齐 peripheral/uart/contract/uart.interface.yaml（IFC-UART-001）。
// cts/rts 为可选 flow_control 能力信号。

interface aix_uart_if (
  input logic clk,
  input logic rst_n
);

  logic tx;
  logic rx;
  logic cts; // capability: flow_control（可选）
  logic rts; // capability: flow_control（可选）

  modport controller (
    output tx, rts,
    input  rx, cts
  );
  modport endpoint (
    input  tx, rts,
    output rx, cts
  );

endinterface : aix_uart_if
