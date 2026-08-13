// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_watchdog_service_if: 看门狗服务接口（View B）。
// 信号集对齐 safety_security/watchdog_service/contract/watchdog_service.interface.yaml（IFC-WDG-001）。

interface aix_watchdog_service_if #(
  parameter int unsigned CHALLENGE_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic                 service_req;
  logic [CHALLENGE_W-1:0] challenge;
  logic [CHALLENGE_W-1:0] response;
  logic                 wdg_status;

  modport controller (
    output service_req, response,
    input  challenge, wdg_status
  );
  modport endpoint (
    input  service_req, response,
    output challenge, wdg_status
  );

endinterface : aix_watchdog_service_if
