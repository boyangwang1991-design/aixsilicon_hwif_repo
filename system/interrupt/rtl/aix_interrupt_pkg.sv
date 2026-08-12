// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_interrupt_pkg: 中断接口类型。

package aix_interrupt_pkg;

  localparam int unsigned INT_DEFAULT_W = 1;

  // 中断请求向量
  typedef logic [INT_DEFAULT_W-1:0] irq_t;

  // 中断源类型：level / pulse
  typedef enum logic {
    IRQ_LEVEL = 1'b0,
    IRQ_PULSE = 1'b1
  } irq_type_t;

  // 中断元数据（供 SoCGen / 软件工具读取）
  typedef struct packed {
    irq_type_t  irq_type;
    logic       polarity;
  } irq_meta_t;

endpackage : aix_interrupt_pkg
