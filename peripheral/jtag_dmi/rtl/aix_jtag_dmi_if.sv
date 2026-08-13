// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_jtag_dmi_if: JTAG 引脚 + RISC-V DMI 接口（View B）。
// 信号集对齐 peripheral/jtag_dmi/contract/jtag_dmi.interface.yaml（IFC-JTAGDMI-001）。
// trst_n 为 reset_line 可选能力；dmi_* 为 DMI 可选通道（ready_valid）。

interface aix_jtag_dmi_if (
  input logic clk,
  input logic rst_n
);

  // JTAG 引脚（tck 可与 clk 异步）
  logic tck;
  logic tms;
  logic tdi;
  logic tdo;
  logic trst_n; // capability: reset_line（可选）

  // DMI 通道（capability: dmi，可选）
  logic       dmi_req_valid;
  logic       dmi_req_ready;
  logic [33:0] dmi_req;
  logic       dmi_rsp_valid;
  logic [33:0] dmi_rsp;

  modport controller (
    output tck, tms, tdi, trst_n,
           dmi_req_valid, dmi_req,
    input  tdo, dmi_req_ready, dmi_rsp_valid, dmi_rsp
  );
  modport endpoint (
    input  tck, tms, tdi, trst_n,
           dmi_req_valid, dmi_req,
    output tdo, dmi_req_ready, dmi_rsp_valid, dmi_rsp
  );

endinterface : aix_jtag_dmi_if
