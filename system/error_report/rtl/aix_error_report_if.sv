// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_error_report_if: 错误上报接口（View B）。

interface aix_error_report_if #(
  parameter int unsigned SYNDROME_W = 32,
  parameter int unsigned SOURCE_ID_W = 8
) (
  input logic clk,
  input logic rst_n
);

  logic                  err_valid;
  logic                  err_ready;
  logic                  err_severity;
  logic [SYNDROME_W-1:0] err_syndrome;
  logic [SOURCE_ID_W-1:0] err_source_id;

  modport source   (output err_valid, err_severity, err_syndrome, err_source_id,
                    input  err_ready);
  modport receiver (input  err_valid, err_severity, err_syndrome, err_source_id,
                    output err_ready);

endinterface : aix_error_report_if
