// SPDX-License-Identifier: Apache-2.0
// Generated from the interface contract. Do not edit.
module aix_crypto_entropy_flat_wrapper #(parameter int unsigned DATA_W = 128)(
  aix_crypto_entropy_if.consumer link,
  input logic [(1)-1:0] req_valid_i,
  output logic [(1)-1:0] req_ready_o,
  input logic [(32)-1:0] req_owner_id_i,
  input logic [(16)-1:0] req_instance_id_i,
  input logic [(32)-1:0] req_epoch_i,
  input logic [(32)-1:0] req_task_id_i,
  input logic [(64)-1:0] req_request_seq_i,
  input logic [(16)-1:0] req_context_id_i,
  input logic [(32)-1:0] req_generation_i,
  input logic [(64)-1:0] req_request_id_i,
  input logic [(32)-1:0] req_length_i,
  output logic [(1)-1:0] rsp_valid_o,
  input logic [(1)-1:0] rsp_ready_i,
  output logic [(32)-1:0] rsp_owner_id_o,
  output logic [(16)-1:0] rsp_instance_id_o,
  output logic [(32)-1:0] rsp_epoch_o,
  output logic [(32)-1:0] rsp_task_id_o,
  output logic [(64)-1:0] rsp_request_seq_o,
  output logic [(16)-1:0] rsp_context_id_o,
  output logic [(32)-1:0] rsp_generation_o,
  output logic [(64)-1:0] rsp_request_id_o,
  output logic [(16)-1:0] rsp_status_o,
  output logic [(DATA_W)-1:0] rsp_data_o,
  output logic [(DATA_W/8)-1:0] rsp_keep_o,
  output logic [(1)-1:0] rsp_last_o,
  output logic [(1)-1:0] rsp_health_ok_o
);
  assign link.req_valid = req_valid_i;
  assign req_ready_o = link.req_ready;
  assign link.req_owner_id = req_owner_id_i;
  assign link.req_instance_id = req_instance_id_i;
  assign link.req_epoch = req_epoch_i;
  assign link.req_task_id = req_task_id_i;
  assign link.req_request_seq = req_request_seq_i;
  assign link.req_context_id = req_context_id_i;
  assign link.req_generation = req_generation_i;
  assign link.req_request_id = req_request_id_i;
  assign link.req_length = req_length_i;
  assign rsp_valid_o = link.rsp_valid;
  assign link.rsp_ready = rsp_ready_i;
  assign rsp_owner_id_o = link.rsp_owner_id;
  assign rsp_instance_id_o = link.rsp_instance_id;
  assign rsp_epoch_o = link.rsp_epoch;
  assign rsp_task_id_o = link.rsp_task_id;
  assign rsp_request_seq_o = link.rsp_request_seq;
  assign rsp_context_id_o = link.rsp_context_id;
  assign rsp_generation_o = link.rsp_generation;
  assign rsp_request_id_o = link.rsp_request_id;
  assign rsp_status_o = link.rsp_status;
  assign rsp_data_o = link.rsp_data;
  assign rsp_keep_o = link.rsp_keep;
  assign rsp_last_o = link.rsp_last;
  assign rsp_health_ok_o = link.rsp_health_ok;
endmodule
