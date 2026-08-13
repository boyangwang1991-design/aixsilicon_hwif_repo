// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_retention_pkg: 数据保持 req/rsp 聚合结构（View A）。
// 信号集对齐 system/retention/contract/retention.interface.yaml（IFC-RET-001）。

package aix_retention_pkg;

  localparam int unsigned RETENTION_CTRL_W = 8;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic                  save_req;
    logic                  restore_req;
    logic [RETENTION_CTRL_W-1:0] retention_ctrl; // capability: ctrl_override（可选）
  } retention_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic retention_ack;
    logic retention_status;
  } retention_rsp_t;

endpackage : aix_retention_pkg
