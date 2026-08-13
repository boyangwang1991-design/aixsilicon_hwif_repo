// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_security_violation_if: 安全违规上报接口（View B）。
// 信号集对齐 safety_security/security_violation/contract/security_violation.interface.yaml（IFC-SECV-001）。

interface aix_security_violation_if #(
  parameter int unsigned SOURCE_W   = 8,
  parameter int unsigned EVIDENCE_W = 64
) (
  input logic clk,
  input logic rst_n
);

  logic                  viol_valid;
  logic                  viol_ready;
  logic [SOURCE_W-1:0]   viol_source;
  logic [7:0]            viol_class;
  logic                  viol_fatal;
  logic [EVIDENCE_W-1:0] viol_evidence;

  modport source (
    output viol_valid, viol_source, viol_class, viol_fatal, viol_evidence,
    input  viol_ready
  );
  modport sink (
    input  viol_valid, viol_source, viol_class, viol_fatal, viol_evidence,
    output viol_ready
  );

endinterface : aix_security_violation_if
