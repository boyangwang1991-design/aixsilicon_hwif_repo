// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_apb3_if: AMBA APB3 接口（View B）。
// 信号集对齐 bus/apb/apb3/contract/apb3.interface.yaml（IFC-APB3-001）。
// 统一角色使用 initiator/target（协议原生别名 master/slave）。

interface aix_apb3_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  // 地址/控制/写数据相位（initiator -> target）
  logic                    psel;
  logic                    penable;
  logic [ADDR_W-1:0]       paddr;
  logic                    pwrite;
  logic [DATA_W-1:0]       pwdata;
  // 响应（target -> initiator）
  logic [DATA_W-1:0]       prdata;
  logic                    pready;
  logic                    pslverr;

  modport initiator (
    output psel, penable, paddr, pwrite, pwdata,
    input  prdata, pready, pslverr
  );
  modport target (
    input  psel, penable, paddr, pwrite, pwdata,
    output prdata, pready, pslverr
  );

endinterface : aix_apb3_if