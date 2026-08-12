// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_req_ack_pkg: request/acknowledge 事件握手类型。

package aix_req_ack_pkg;

  typedef struct packed {
    logic req;
  } req_ack_req_t;

  typedef struct packed {
    logic ack;
  } req_ack_rsp_t;

endpackage : aix_req_ack_pkg
