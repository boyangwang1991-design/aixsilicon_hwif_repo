// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_fifo_push_pop_pkg: FIFO 推/弹接口类型。

package aix_fifo_push_pop_pkg;

  localparam int unsigned FIFO_DATA_W = 32;
  localparam int unsigned FIFO_DEPTH_LOG2 = 4;

  typedef struct packed {
    logic                   valid;
    logic [FIFO_DATA_W-1:0] data;
  } fifo_push_req_t;

  typedef struct packed {
    logic                   valid;
    logic [FIFO_DATA_W-1:0] data;
  } fifo_pop_rsp_t;

  typedef struct packed {
    logic                        full;
    logic                        empty;
    logic [FIFO_DEPTH_LOG2:0]    level;
  } fifo_status_t;

endpackage : aix_fifo_push_pop_pkg
