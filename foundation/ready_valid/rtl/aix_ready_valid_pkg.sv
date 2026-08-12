// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_ready_valid_pkg: ready/valid 流接口的 packed request/response 结构。
// View A —— 内部 RTL 首选。与 contract/ready_valid.interface.yaml 保持一致性
// （由 sv_consistency_check 工具校验）。

package aix_ready_valid_pkg;

  // 可选能力开关（由 Profile / 参数冻结）
  localparam logic RV_EN_KEEP  = 1'b0;
  localparam logic RV_EN_LAST  = 1'b0;
  localparam logic RV_EN_USER  = 1'b0;

  // 默认数据位宽
  localparam int unsigned RV_DATA_W = 32;
  localparam int unsigned RV_USER_W = 1;

  // ---------------------------------------------------------------------
  // Request（source → sink，payload 通道）
  // ---------------------------------------------------------------------
  typedef struct packed {
    logic                  valid;
    logic [RV_DATA_W-1:0]  data;
    logic [RV_DATA_W/8-1:0] keep;    // capability: byte_keep
    logic                  last;     // capability: packet_boundary
    logic [RV_USER_W-1:0]  user;     // capability: user_sideband
  } ready_valid_req_t;

  // ---------------------------------------------------------------------
  // Response（sink → source，仅含 ready）
  // ---------------------------------------------------------------------
  typedef struct packed {
    logic                  ready;
  } ready_valid_rsp_t;

  // 别名（兼容历史命名，不作为新类型）
  typedef ready_valid_req_t  aix_stream_req_t;
  typedef ready_valid_rsp_t  aix_stream_rsp_t;

endpackage : aix_ready_valid_pkg
