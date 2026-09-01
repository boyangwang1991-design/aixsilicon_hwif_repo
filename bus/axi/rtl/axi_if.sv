// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// axi_if: AXI4 接口（View B）。
// 供 VIP / TB / 局部集成使用，提供 initiator/target modport。
// 信号命名遵循 AXI 标准（无下划线，如 awvalid/awaddr），与契约 axi.interface.yaml 一致。

interface axi_if #(
  parameter int unsigned ID_W   = 8,
  parameter int unsigned ADDR_W = 64,
  parameter int unsigned DATA_W = 64,
  parameter int unsigned USER_W = 1
) (
  input logic clk,
  input logic rst_n
);

  // AW
  logic                  awvalid;
  logic                  awready;
  logic [ID_W-1:0]       awid;
  logic [ADDR_W-1:0]     awaddr;
  logic [7:0]            awlen;
  logic [2:0]            awsize;
  logic [1:0]            awburst;
  logic                  awlock;
  logic [3:0]            awcache;
  logic [2:0]            awprot;
  logic [3:0]            awqos;
  logic [3:0]            awregion;
  logic [5:0]            awatop;
  logic [USER_W-1:0]     awuser;
  // W
  logic                  wvalid;
  logic                  wready;
  logic [DATA_W-1:0]     wdata;
  logic [DATA_W/8-1:0]   wstrb;
  logic                  wlast;
  logic [USER_W-1:0]     wuser;
  // B
  logic                  bvalid;
  logic                  bready;
  logic [ID_W-1:0]       bid;
  logic [1:0]            bresp;
  logic [USER_W-1:0]     buser;
  // AR
  logic                  arvalid;
  logic                  arready;
  logic [ID_W-1:0]       arid;
  logic [ADDR_W-1:0]     araddr;
  logic [7:0]            arlen;
  logic [2:0]            arsize;
  logic [1:0]            arburst;
  logic                  arlock;
  logic [3:0]            arcache;
  logic [2:0]            arprot;
  logic [3:0]            arqos;
  logic [3:0]            arregion;
  logic [USER_W-1:0]     aruser;
  // R
  logic                  rvalid;
  logic                  rready;
  logic [ID_W-1:0]       rid;
  logic [DATA_W-1:0]     rdata;
  logic [1:0]            rresp;
  logic                  rlast;
  logic [USER_W-1:0]     ruser;

  modport initiator (
    output awvalid, awid, awaddr, awlen, awsize, awburst,
           awlock, awcache, awprot, awqos, awregion, awatop, awuser,
           wvalid, wdata, wstrb, wlast, wuser,
           bready,
           arvalid, arid, araddr, arlen, arsize, arburst,
           arlock, arcache, arprot, arqos, arregion, aruser,
           rready,
    input  awready, wready,
           bvalid, bid, bresp, buser,
           arready,
           rvalid, rid, rdata, rresp, rlast, ruser
  );
  modport target (
    input  awvalid, awid, awaddr, awlen, awsize, awburst,
           awlock, awcache, awprot, awqos, awregion, awatop, awuser,
           wvalid, wdata, wstrb, wlast, wuser,
           bready,
           arvalid, arid, araddr, arlen, arsize, arburst,
           arlock, arcache, arprot, arqos, arregion, aruser,
           rready,
    output awready, wready,
           bvalid, bid, bresp, buser,
           arready,
           rvalid, rid, rdata, rresp, rlast, ruser
  );

endinterface : axi_if
