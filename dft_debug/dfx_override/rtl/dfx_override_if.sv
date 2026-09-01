// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// dfx_override_if: DFX 覆盖接口（View B）。
// 信号集对齐 dft_debug/dfx_override/contract/dfx_override.interface.yaml（IFC-DFX-001）。

interface dfx_override_if (
  input logic clk,
  input logic rst_n
);

  logic clk_override;
  logic rst_override;
  logic iso_override;
  logic dfx_override_ack;
  logic safety_qualified;

  modport controller (
    output clk_override, rst_override, iso_override,
    input  dfx_override_ack, safety_qualified
  );
  modport endpoint (
    input  clk_override, rst_override, iso_override,
    output dfx_override_ack, safety_qualified
  );

endinterface : dfx_override_if
