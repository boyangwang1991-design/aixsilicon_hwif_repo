// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_mgmt_pkg: HAC-MGMT 管理接口类型（View A）。
// 依赖：aix_common_pkg / aix_hac_if_pkg。

package aix_hac_mgmt_pkg;

  import aix_common_pkg::*;
  import aix_hac_if_pkg::*;

  // 生命周期状态
  typedef enum logic [2:0] {
    MGMT_RUN     = 3'd0,
    MGMT_DRAIN   = 3'd1,
    MGMT_QUIESCENT = 3'd2,
    MGMT_RESET   = 3'd3,
    MGMT_ISOLATE = 3'd4,
    MGMT_FATAL   = 3'd5
  } hac_mgmt_state_t;

  // 管理状态
  typedef struct packed {
    logic quiescent;
    logic idle;
    logic clock_gate_ok;
    logic fatal_state;
  } hac_mgmt_status_t;

endpackage : aix_hac_mgmt_pkg
