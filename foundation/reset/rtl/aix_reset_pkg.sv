// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_reset_pkg: 复位接口类型与元数据。

package aix_reset_pkg;

  // 复位极性
  typedef enum logic {
    RST_ACTIVE_LOW  = 1'b0,
    RST_ACTIVE_HIGH = 1'b1
  } reset_polarity_t;

  // 复位断言/去断言同步性
  typedef enum logic [1:0] {
    RST_SYNC      = 2'd0,
    RST_ASYNC     = 2'd1,
    RST_MESOCHRONOUS = 2'd2
  } reset_sync_t;

  // 复位域元数据（供工具/SoCGen 读取）
  typedef struct packed {
    reset_polarity_t polarity;
    reset_sync_t     assertion;
    reset_sync_t     deassertion;
    logic            can_interrupt_transactions;
  } reset_meta_t;

endpackage : aix_reset_pkg
