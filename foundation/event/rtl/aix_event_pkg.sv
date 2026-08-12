// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_event_pkg: 事件接口类型。

package aix_event_pkg;

  typedef enum logic [1:0] {
    EVT_PULSE  = 2'd0,
    EVT_LEVEL  = 2'd1,
    EVT_TOGGLE = 2'd2
  } event_type_t;

  // 事件向量（多事件聚合，宽度可参数化）
  typedef struct packed {
    logic [31:0] events;
  } event_vector_t;

endpackage : aix_event_pkg
