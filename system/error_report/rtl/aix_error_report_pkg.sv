// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_error_report_pkg: 错误上报接口类型。

package aix_error_report_pkg;

  localparam int unsigned ERR_SYNDROME_W = 32;
  localparam int unsigned ERR_SOURCE_ID_W = 8;

  // 严重度
  typedef enum logic {
    ERR_RECOVERABLE = 1'b0,
    ERR_FATAL       = 1'b1
  } err_severity_t;

  // 错误上报载荷
  typedef struct packed {
    logic                       valid;
    err_severity_t              severity;
    logic [ERR_SYNDROME_W-1:0]  syndrome;
    logic [ERR_SOURCE_ID_W-1:0] source_id;
  } err_report_t;

  typedef struct packed {
    logic ready;
  } err_report_rsp_t;

endpackage : aix_error_report_pkg
