// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_stream_pkg: HAC-STREAM 流式数据接口类型（View A）。
// 依赖：aix_common_pkg / aix_hac_if_pkg。

package aix_hac_stream_pkg;

  import aix_common_pkg::*;
  import aix_hac_if_pkg::*;

  // 流数据单元（packed）
  typedef struct packed {
    logic [DATA_W-1:0] data;
    logic [DATA_W/8-1:0] keep;
    logic              last;
    logic [ID_W-1:0]   id;
    logic [USER_W-1:0] user;
  } hac_stream_t;

endpackage : aix_hac_stream_pkg
