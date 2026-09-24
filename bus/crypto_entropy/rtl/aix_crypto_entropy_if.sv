// SPDX-License-Identifier: Apache-2.0
// Generated from the interface contract. Do not edit.

interface aix_crypto_entropy_if #(parameter int unsigned DATA_W = 128)(
  input logic clk,
  input logic reset_n
);
  logic [(1)-1:0] req_valid;
  logic [(1)-1:0] req_ready;
  logic [(32)-1:0] req_owner_id;
  logic [(16)-1:0] req_instance_id;
  logic [(32)-1:0] req_epoch;
  logic [(32)-1:0] req_task_id;
  logic [(64)-1:0] req_request_seq;
  logic [(16)-1:0] req_context_id;
  logic [(32)-1:0] req_generation;
  logic [(64)-1:0] req_request_id;
  logic [(32)-1:0] req_length;
  logic [(1)-1:0] rsp_valid;
  logic [(1)-1:0] rsp_ready;
  logic [(32)-1:0] rsp_owner_id;
  logic [(16)-1:0] rsp_instance_id;
  logic [(32)-1:0] rsp_epoch;
  logic [(32)-1:0] rsp_task_id;
  logic [(64)-1:0] rsp_request_seq;
  logic [(16)-1:0] rsp_context_id;
  logic [(32)-1:0] rsp_generation;
  logic [(64)-1:0] rsp_request_id;
  logic [(16)-1:0] rsp_status;
  logic [(DATA_W)-1:0] rsp_data;
  logic [(DATA_W/8)-1:0] rsp_keep;
  logic [(1)-1:0] rsp_last;
  logic [(1)-1:0] rsp_health_ok;
  modport consumer (
    input clk,
    input reset_n,
    output req_valid,
    input req_ready,
    output req_owner_id,
    output req_instance_id,
    output req_epoch,
    output req_task_id,
    output req_request_seq,
    output req_context_id,
    output req_generation,
    output req_request_id,
    output req_length,
    input rsp_valid,
    output rsp_ready,
    input rsp_owner_id,
    input rsp_instance_id,
    input rsp_epoch,
    input rsp_task_id,
    input rsp_request_seq,
    input rsp_context_id,
    input rsp_generation,
    input rsp_request_id,
    input rsp_status,
    input rsp_data,
    input rsp_keep,
    input rsp_last,
    input rsp_health_ok
  );
  modport source (
    input clk,
    input reset_n,
    input req_valid,
    output req_ready,
    input req_owner_id,
    input req_instance_id,
    input req_epoch,
    input req_task_id,
    input req_request_seq,
    input req_context_id,
    input req_generation,
    input req_request_id,
    input req_length,
    output rsp_valid,
    input rsp_ready,
    output rsp_owner_id,
    output rsp_instance_id,
    output rsp_epoch,
    output rsp_task_id,
    output rsp_request_seq,
    output rsp_context_id,
    output rsp_generation,
    output rsp_request_id,
    output rsp_status,
    output rsp_data,
    output rsp_keep,
    output rsp_last,
    output rsp_health_ok
  );
  modport monitor (
    input clk,
    input reset_n,
    input req_valid,
    input req_ready,
    input req_owner_id,
    input req_instance_id,
    input req_epoch,
    input req_task_id,
    input req_request_seq,
    input req_context_id,
    input req_generation,
    input req_request_id,
    input req_length,
    input rsp_valid,
    input rsp_ready,
    input rsp_owner_id,
    input rsp_instance_id,
    input rsp_epoch,
    input rsp_task_id,
    input rsp_request_seq,
    input rsp_context_id,
    input rsp_generation,
    input rsp_request_id,
    input rsp_status,
    input rsp_data,
    input rsp_keep,
    input rsp_last,
    input rsp_health_ok
  );
endinterface : aix_crypto_entropy_if
