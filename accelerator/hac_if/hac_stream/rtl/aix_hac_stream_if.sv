// Copyright (c) 2026 AIXSILICON
// SPDX-License-Identifier: Apache-2.0
//
// aix_hac_stream_if: 由 tools/view_generate/view_generate.py 从 YAML Contract 确定性生成。
// 契约来源：IFC-HAC_STRM-001。禁止手工修改，改契约后重新生成。

interface aix_hac_stream_if#(
  parameter int unsigned DATA_W = 128,
  parameter int unsigned ID_W = 4,
  parameter int unsigned USER_W = 8
) (
  input  logic clk,
  input  logic rst_n
);

  logic valid; // channel=data
  logic ready; // channel=data
  logic [DATA_W-1:0] data; // channel=data
  logic [DATA_W/8-1:0] keep; // channel=data
  logic last; // channel=data
  logic [ID_W-1:0] id; // channel=data
  logic [USER_W-1:0] user; // channel=data

  modport producer (
    output valid , data , keep , last , id , user,
    input  ready
  );

  modport consumer (
    output ready,
    input  valid , data , keep , last , id , user
  );

endinterface : aix_hac_stream_if
