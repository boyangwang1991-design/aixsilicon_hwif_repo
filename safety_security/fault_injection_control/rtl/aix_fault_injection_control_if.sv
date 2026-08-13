// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_fault_injection_control_if: 故障注入控制接口（View B）。
// 信号集对齐 safety_security/fault_injection_control/contract/fault_injection_control.interface.yaml（IFC-FI-001）。

interface aix_fault_injection_control_if (
  input logic clk,
  input logic rst_n
);

  logic       inject_en;
  logic [3:0] inject_type;
  logic [31:0] inject_target;
  logic       inject_trigger;
  logic       inject_status;

  modport controller (
    output inject_en, inject_type, inject_target, inject_trigger,
    input  inject_status
  );
  modport endpoint (
    input  inject_en, inject_type, inject_target, inject_trigger,
    output inject_status
  );

endinterface : aix_fault_injection_control_if
