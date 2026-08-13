// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_isolation_if: 电源隔离接口（View B）。
// 信号集对齐 system/isolation/contract/isolation.interface.yaml（IFC-ISO-001）。
// clamp_policy 为可选能力信号。

interface aix_isolation_if (
  input logic clk,
  input logic rst_n
);

  logic       isolate_req;
  logic       isolate_ack;
  logic       isolate_status;
  logic [3:0] clamp_policy; // capability: clamp_policy（可选）

  modport controller (
    output isolate_req, clamp_policy,
    input  isolate_ack, isolate_status
  );
  modport endpoint (
    input  isolate_req, clamp_policy,
    output isolate_ack, isolate_status
  );

endinterface : aix_isolation_if
