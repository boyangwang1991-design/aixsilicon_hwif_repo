// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// hac_stream_pkg: HAC-STREAM 流式数据接口类型（View A）。
// 依赖：common_pkg / hac_if_pkg。

package hac_stream_pkg;

  import common_pkg::*;
  import hac_if_pkg::*;

  // 流数据单元（packed）
  typedef struct packed {
    logic [DATA_W-1:0] data;
    logic [DATA_W/8-1:0] keep;
    logic              last;
    logic [ID_W-1:0]   id;
    logic [USER_W-1:0] user;
  } hac_stream_t;

endpackage : hac_stream_pkg
