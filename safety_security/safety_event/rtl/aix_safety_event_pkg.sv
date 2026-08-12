// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_safety_event_pkg: 安全事件接口类型。

package aix_safety_event_pkg;

  import aix_common_pkg::*;

  localparam int unsigned SAFE_FAULT_ID_W = 16;
  localparam int unsigned SAFE_TS_W       = 32;
  localparam int unsigned SAFE_DOMAIN_W   = 8;

  // 严重度
  typedef enum logic {
    SAFE_RECOVERABLE = 1'b0,
    SAFE_FATAL       = 1'b1
  } safety_severity_t;

  // 安全事件载荷
  typedef struct packed {
    logic                          valid;
    logic [SAFE_FAULT_ID_W-1:0]    fault_id;
    safety_severity_t              severity;
    logic [SAFE_DOMAIN_W-1:0]      domain;
    logic [SAFE_TS_W-1:0]          timestamp;
  } safety_event_t;

  typedef struct packed {
    logic ready;
    logic ack;  // capability: acknowledged
  } safety_event_rsp_t;

endpackage : aix_safety_event_pkg
