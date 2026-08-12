// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_common_typedef.svh
// 通用 typedef 宏（include file）。
// 与 aix_common_pkg 内容一致，供不使用 package import 的旧式代码通过
// `include 方式获取类型。新代码应优先 import aix_common_pkg::*。
//
// 注意：本文件由工具对照 YAML/package 进行一致性检查，
//       禁止手工引入与 package 冲突的定义。

`ifndef AIX_COMMON_TYPEDEF_SVH
`define AIX_COMMON_TYPEDEF_SVH

  typedef logic                          aix_bool_t;
  typedef logic [8-1:0]                  aix_id_t;
  typedef logic [3:0]                    aix_err_t;
  typedef logic [2:0]                    aix_status_t;

  // 宏形式错误码（供 parameter/localparam 使用）
  `define AIX_ERR_OK        4'h0
  `define AIX_ERR_DECERR    4'h1
  `define AIX_ERR_SLVERR    4'h2
  `define AIX_ERR_PARERR    4'h3
  `define AIX_ERR_SECERR    4'h4
  `define AIX_ERR_TIMEOUT   4'h5
  `define AIX_ERR_PROT      4'h6

`endif
