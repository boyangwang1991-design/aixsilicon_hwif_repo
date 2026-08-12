// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_common_assign.svh
// 通用 assign 宏（include file）。
// 本文件为占位模板，预留通用赋值/转换宏；
// 各协议族的 assign 宏位于各自 rtl/<name>_assign.svh。

`ifndef AIX_COMMON_ASSIGN_SVH
`define AIX_COMMON_ASSIGN_SVH

  // 例：将 bool 源赋给 1 比特目标
  `define AIX_ASSIGN_BOOL(dst, src) \
    assign dst = (src);

`endif
