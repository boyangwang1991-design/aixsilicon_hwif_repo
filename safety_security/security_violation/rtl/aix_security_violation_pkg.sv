// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_security_violation_pkg: 安全违规聚合结构（View A）。
// 信号集对齐 safety_security/security_violation/contract/security_violation.interface.yaml（IFC-SECV-001）。

package aix_security_violation_pkg;

  localparam int unsigned SECV_SOURCE_W   = 8;
  localparam int unsigned SECV_EVIDENCE_W = 64;

  // 违规事件（source -> sink，ready/valid 独立）
  typedef struct packed {
    logic                         viol_valid;
    logic                         viol_ready;
    logic [SECV_SOURCE_W-1:0]     viol_source;
    logic [7:0]                   viol_class;
    logic                         viol_fatal;
    logic [SECV_EVIDENCE_W-1:0]   viol_evidence;
  } security_violation_t;

endpackage : aix_security_violation_pkg
