// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_ahb_lite_if: AMBA AHB-Lite 接口（View B）。
// 信号集对齐 bus/ahb_lite/contract/ahb_lite.interface.yaml（IFC-AHB-001）。
// 统一角色使用 initiator/target（协议原生别名 master/slave）。

interface aix_ahb_lite_if #(
  parameter int unsigned ADDR_W = 32,
  parameter int unsigned DATA_W = 32
) (
  input logic clk,
  input logic rst_n
);

  // 地址/控制相位（initiator -> target）
  logic [ADDR_W-1:0] haddr;
  logic              hwrite;
  logic [1:0]        htrans;
  logic [2:0]        hsize;
  logic [2:0]        hburst;
  logic [3:0]        hprot;
  // 写数据（initiator -> target）
  logic [DATA_W-1:0] hwdata;
  // 响应（target -> initiator）
  logic [DATA_W-1:0] hrdata;
  logic              hresp;
  logic              hready;
  logic              hready_in;

  modport initiator (
    output haddr, hwrite, htrans, hsize, hburst, hprot, hwdata,
    input  hrdata, hresp, hready, hready_in
  );
  modport target (
    input  haddr, hwrite, htrans, hsize, hburst, hprot, hwdata,
    output hrdata, hresp, hready, hready_in
  );

endinterface : aix_ahb_lite_if
