// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_watchdog_service_pkg: 看门狗服务 req/rsp 聚合结构（View A）。
// 信号集对齐 safety_security/watchdog_service/contract/watchdog_service.interface.yaml（IFC-WDG-001）。

package aix_watchdog_service_pkg;

  localparam int unsigned WDG_CHALLENGE_W = 32;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic                         service_req;
    logic [WDG_CHALLENGE_W-1:0]   response;
  } watchdog_service_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic [WDG_CHALLENGE_W-1:0] challenge;
    logic                       wdg_status;
  } watchdog_service_rsp_t;

endpackage : aix_watchdog_service_pkg
