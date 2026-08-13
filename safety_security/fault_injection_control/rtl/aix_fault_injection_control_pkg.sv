// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_fault_injection_control_pkg: 故障注入控制 req/rsp 聚合结构（View A）。
// 信号集对齐 safety_security/fault_injection_control/contract/fault_injection_control.interface.yaml（IFC-FI-001）。
// 注入必须经过安全限定（semantics: qualified），仅用于安全验证环境。

package aix_fault_injection_control_pkg;

  // 注入请求（controller -> endpoint）
  typedef struct packed {
    logic       inject_en;
    logic [3:0] inject_type;
    logic [31:0] inject_target;
    logic       inject_trigger;
  } fault_injection_req_t;

  // 状态（endpoint -> controller）
  typedef struct packed {
    logic inject_status;
  } fault_injection_rsp_t;

endpackage : aix_fault_injection_control_pkg
