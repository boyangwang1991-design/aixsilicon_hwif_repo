// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_domain_health_if: 域健康状态接口（View B）。
// 信号集对齐 safety_security/domain_health/contract/domain_health.interface.yaml（IFC-DH-001）。
// recovery_in_progress 为可选 recovery 能力信号。

interface aix_domain_health_if (
  input logic clk,
  input logic rst_n
);

  logic alive;
  logic degraded;
  logic failed;
  logic recovery_in_progress; // capability: recovery（可选）

  modport source (
    output alive, degraded, failed, recovery_in_progress
  );
  modport sink (
    input  alive, degraded, failed, recovery_in_progress
  );

endinterface : aix_domain_health_if
