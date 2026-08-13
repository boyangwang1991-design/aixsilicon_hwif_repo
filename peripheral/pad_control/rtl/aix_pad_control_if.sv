// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_pad_control_if: Pad 控制接口（View B）。
// 信号集对齐 peripheral/pad_control/contract/pad_control.interface.yaml（IFC-PAD-001）。
// 双向物理引脚拆分为 *_i / *_o / *_oe_o；可选 pull/drive/schmitt/slew。

interface aix_pad_control_if #(
  parameter int unsigned PAD_W = 32
) (
  input logic clk,
  input logic rst_n
);

  logic [PAD_W-1:0] pad_i;
  logic [PAD_W-1:0] pad_o;
  logic [PAD_W-1:0] pad_oe_o;
  logic [PAD_W-1:0] pad_pull_en; // capability: pull_control（可选）
  logic [PAD_W-1:0] pad_drive;   // capability: drive_config（可选）
  logic [PAD_W-1:0] pad_schmitt; // capability: schmitt（可选）
  logic [PAD_W-1:0] pad_slew;    // capability: slew_control（可选）

  modport controller (
    input  pad_i,
    output pad_o, pad_oe_o, pad_pull_en, pad_drive, pad_schmitt, pad_slew
  );
  modport endpoint (
    output pad_i,
    input  pad_o, pad_oe_o, pad_pull_en, pad_drive, pad_schmitt, pad_slew
  );

endinterface : aix_pad_control_if
