// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_cache_maintenance_pkg: 缓存维护 req/rsp 聚合结构（View A）。
// 信号集对齐 memory/cache_maintenance/contract/cache_maintenance.interface.yaml（IFC-CM-001）。

package aix_cache_maintenance_pkg;

  localparam int unsigned CM_TAG_W = 32;
  localparam int unsigned CM_OP_W  = 4;

  // 维护操作编码（OP_W 低 2 位示意）
  localparam logic [3:0] CM_OP_INVALIDATE = 4'd0;
  localparam logic [3:0] CM_OP_CLEAN      = 4'd1;
  localparam logic [3:0] CM_OP_FENCE      = 4'd2;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic [CM_OP_W-1:0]  maint_op;
    logic [CM_TAG_W-1:0] maint_tag;
    logic                maint_req;
  } cache_maintenance_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic maint_ack;
    logic maint_done;
  } cache_maintenance_rsp_t;

endpackage : aix_cache_maintenance_pkg
