// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_common_pkg: 所有接口族共用的基础类型与工具。
// - bool / logic 别名
// - 通用 ID 类型
// - 通用 error code 枚举
// - 通用类型工具函数
//
// 本包只含通用类型，不包含任何协议专用信号定义。

package aix_common_pkg;

  // ---------------------------------------------------------------------
  // 基础标量类型
  // ---------------------------------------------------------------------
  // 显式 bool，避免 1'b0/1'b1 与多比特混淆
  typedef logic bool_t;

  localparam logic TRUE  = 1'b1;
  localparam logic FALSE = 1'b0;

  // 通用宽度常量（可由参数化接口覆盖，默认取组织标准）
  localparam int unsigned INT_W   = 32;
  localparam int unsigned ID_W    = 8;
  localparam int unsigned USER_W  = 1;

  // ---------------------------------------------------------------------
  // 通用 ID 类型
  // ---------------------------------------------------------------------
  // 接口/通道实例 ID；协议族可派生专用 ID 类型（如 axi_id_t）
  typedef logic [ID_W-1:0]  id_t;

  // ---------------------------------------------------------------------
  // 通用错误码
  // ---------------------------------------------------------------------
  // OK:      无错误
  // DECERR:  解码/地址错误
  // SLVERR:  从设备错误
  // PARERR:  完整性/校验错误（功能安全 sideband 使用）
  // SECERR:  安全违规
  // TIMEOUT: 响应超时
  // PROT:    保护属性违规
  typedef enum logic [3:0] {
    OK       = 4'h0,
    DECERR   = 4'h1,
    SLVERR   = 4'h2,
    PARERR   = 4'h3,
    SECERR   = 4'h4,
    TIMEOUT  = 4'h5,
    PROT     = 4'h6
  } err_t;

  // 简化两态 error 响应（用于 ready/valid 类单拍响应）
  typedef enum logic {
    RESP_OK  = 1'b0,
    RESP_ERR = 1'b1
  } resp_err_t;

  // ---------------------------------------------------------------------
  // 通用状态/标志位
  // ---------------------------------------------------------------------
  typedef enum logic [2:0] {
    ST_IDLE   = 3'd0,
    ST_BUSY   = 3'd1,
    ST_DONE   = 3'd2,
    ST_ERROR  = 3'd3,
    ST_STALL  = 3'd4
  } status_t;

  // ---------------------------------------------------------------------
  // 类型工具函数
  // ---------------------------------------------------------------------
  // 将任意 1 比特条件收敛为 bool_t
  function automatic bool_t to_bool(input logic cond);
    return cond;
  endfunction

  // 计算 $bits 并返回位宽（便于参数化断言/文档工具使用）
  function automatic int unsigned bit_width(input int unsigned value);
    int unsigned w = 0;
    while ((1 << w) < value) w++;
    return w;
  endfunction

endpackage : aix_common_pkg
