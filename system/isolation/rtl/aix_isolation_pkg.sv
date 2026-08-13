// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_isolation_pkg: 电源隔离 req/rsp 聚合结构（View A）。
// 信号集对齐 system/isolation/contract/isolation.interface.yaml（IFC-ISO-001）。

package aix_isolation_pkg;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic isolate_req;
    logic [3:0] clamp_policy; // capability: clamp_policy（可选）
  } isolation_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic isolate_ack;
    logic isolate_status;
  } isolation_rsp_t;

endpackage : aix_isolation_pkg
