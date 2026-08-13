// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_pwm_if: PWM 输出接口（View B）。
// 信号集对齐 peripheral/pwm/contract/pwm.interface.yaml（IFC-PWM-001）。
// pwm_ch_n / pwm_dead_time 为可选能力信号。

interface aix_pwm_if #(
  parameter int unsigned CH_W = 4
) (
  input logic clk,
  input logic rst_n
);

  logic [CH_W-1:0] pwm_ch;
  logic [CH_W-1:0] pwm_ch_n;      // capability: complementary（可选）
  logic [7:0]      pwm_dead_time; // capability: dead_time（可选）

  modport controller (
    output pwm_ch, pwm_ch_n, pwm_dead_time
  );
  modport endpoint (
    input  pwm_ch, pwm_ch_n, pwm_dead_time
  );

endinterface : aix_pwm_if
