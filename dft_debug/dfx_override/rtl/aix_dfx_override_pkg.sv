// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_dfx_override_pkg: DFX 覆盖 req/rsp 聚合结构（View A）。
// 信号集对齐 dft_debug/dfx_override/contract/dfx_override.interface.yaml（IFC-DFX-001）。

package aix_dfx_override_pkg;

  // 请求（controller -> endpoint）
  typedef struct packed {
    logic clk_override;
    logic rst_override;
    logic iso_override;
  } dfx_override_req_t;

  // 响应（endpoint -> controller）
  typedef struct packed {
    logic dfx_override_ack;
    logic safety_qualified;
  } dfx_override_rsp_t;

endpackage : aix_dfx_override_pkg
