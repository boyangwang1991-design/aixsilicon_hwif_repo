// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_event_pkg: HAC-EVENT 事件接口类型（View A）。
// 依赖：aix_common_pkg / aix_hac_if_pkg。

package aix_hac_event_pkg;

  import aix_common_pkg::*;
  import aix_hac_if_pkg::*;

  // 事件单元
  typedef struct packed {
    hac_event_type_t event_type;
    hac_severity_t   severity;
    logic [ID_W-1:0] source;
    logic [JOB_W-1:0] job_id;
    logic [15:0]     code;
    logic [31:0]     info;
  } hac_event_t;

endpackage : aix_hac_event_pkg
