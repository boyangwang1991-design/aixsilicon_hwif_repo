// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_cache_maintenance_if: 缓存维护接口（View B）。
// 信号集对齐 memory/cache_maintenance/contract/cache_maintenance.interface.yaml（IFC-CM-001）。

interface aix_cache_maintenance_if #(
  parameter int unsigned TAG_W = 32,
  parameter int unsigned OP_W  = 4
) (
  input logic clk,
  input logic rst_n
);

  logic [OP_W-1:0]  maint_op;
  logic [TAG_W-1:0] maint_tag;
  logic             maint_req;
  logic             maint_ack;
  logic             maint_done;

  modport controller (
    output maint_op, maint_tag, maint_req,
    input  maint_ack, maint_done
  );
  modport endpoint (
    input  maint_op, maint_tag, maint_req,
    output maint_ack, maint_done
  );

endinterface : aix_cache_maintenance_if
