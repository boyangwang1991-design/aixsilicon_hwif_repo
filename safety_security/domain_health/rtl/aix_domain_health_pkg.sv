// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_domain_health_pkg: 域健康状态聚合结构（View A）。
// 信号集对齐 safety_security/domain_health/contract/domain_health.interface.yaml（IFC-DH-001）。

package aix_domain_health_pkg;

  // 健康状态（source -> sink）
  typedef struct packed {
    logic alive;
    logic degraded;
    logic failed;
    logic recovery_in_progress; // capability: recovery（可选）
  } domain_health_t;

endpackage : aix_domain_health_pkg
