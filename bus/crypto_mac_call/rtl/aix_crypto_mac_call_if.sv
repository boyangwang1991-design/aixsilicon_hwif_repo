// SPDX-License-Identifier: Apache-2.0
// Generated from the interface contract. Do not edit.

interface aix_crypto_mac_call_if #(parameter int unsigned DATA_W = 128)(
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
  logic [(64)-1:0] req_invocation_id;
  logic [(8)-1:0] req_action;
  logic [(64)-1:0] req_lease_token;
  logic [(3)-1:0] req_algorithm;
  logic [(16)-1:0] req_operation;
  logic [(8)-1:0] req_template;
  logic [(32)-1:0] req_policy_epoch;
  logic [(8)-1:0] req_key_source;
  logic [(64)-1:0] req_key_ref;
  logic [(32)-1:0] req_key_epoch;
  logic [(32)-1:0] req_key_length;
  logic [(32)-1:0] req_tag_length;
  logic [(8)-1:0] req_part_count;
  logic [(696)-1:0] req_message_parts;
  logic [(8)-1:0] req_iteration;
  logic [(64)-1:0] req_result_sink_ref;
  logic [(1)-1:0] rsp_valid;
  logic [(1)-1:0] rsp_ready;
  logic [(32)-1:0] rsp_owner_id;
  logic [(16)-1:0] rsp_instance_id;
  logic [(32)-1:0] rsp_epoch;
  logic [(32)-1:0] rsp_task_id;
  logic [(64)-1:0] rsp_request_seq;
  logic [(16)-1:0] rsp_context_id;
  logic [(32)-1:0] rsp_generation;
  logic [(64)-1:0] rsp_invocation_id;
  logic [(8)-1:0] rsp_action;
  logic [(64)-1:0] rsp_lease_token;
  logic [(16)-1:0] rsp_status;
  logic [(1)-1:0] rsp_auth_valid;
  logic [(1)-1:0] rsp_auth_ok;
  logic [(64)-1:0] rsp_result_ref;
  logic [(32)-1:0] rsp_result_epoch;
  logic [(64)-1:0] rsp_result_bytes;
  logic [(64)-1:0] rsp_consumed_public;
  logic [(64)-1:0] rsp_consumed_secret;
  logic [(64)-1:0] rsp_produced;
  logic [(1)-1:0] rsp_cleanup_done;
  logic [(8)-1:0] rsp_object_state;
  logic [(1)-1:0] public_data_valid;
  logic [(1)-1:0] public_data_ready;
  logic [(32)-1:0] public_data_owner_id;
  logic [(16)-1:0] public_data_instance_id;
  logic [(32)-1:0] public_data_epoch;
  logic [(32)-1:0] public_data_task_id;
  logic [(64)-1:0] public_data_request_seq;
  logic [(16)-1:0] public_data_context_id;
  logic [(32)-1:0] public_data_generation;
  logic [(64)-1:0] public_data_invocation_id;
  logic [(64)-1:0] public_data_lease_token;
  logic [(8)-1:0] public_data_source;
  logic [(64)-1:0] public_data_offset;
  logic [(DATA_W)-1:0] public_data_data;
  logic [(DATA_W/8)-1:0] public_data_keep;
  logic [(1)-1:0] public_data_last;
  logic [(1)-1:0] control_req_valid;
  logic [(1)-1:0] control_req_ready;
  logic [(32)-1:0] control_req_owner_id;
  logic [(16)-1:0] control_req_instance_id;
  logic [(32)-1:0] control_req_epoch;
  logic [(32)-1:0] control_req_task_id;
  logic [(64)-1:0] control_req_request_seq;
  logic [(16)-1:0] control_req_context_id;
  logic [(32)-1:0] control_req_generation;
  logic [(64)-1:0] control_req_invocation_id;
  logic [(64)-1:0] control_req_lease_token;
  logic [(8)-1:0] control_req_action;
  logic [(64)-1:0] control_req_control_id;
  logic [(1)-1:0] control_rsp_valid;
  logic [(1)-1:0] control_rsp_ready;
  logic [(32)-1:0] control_rsp_owner_id;
  logic [(16)-1:0] control_rsp_instance_id;
  logic [(32)-1:0] control_rsp_epoch;
  logic [(32)-1:0] control_rsp_task_id;
  logic [(64)-1:0] control_rsp_request_seq;
  logic [(16)-1:0] control_rsp_context_id;
  logic [(32)-1:0] control_rsp_generation;
  logic [(64)-1:0] control_rsp_invocation_id;
  logic [(64)-1:0] control_rsp_lease_token;
  logic [(64)-1:0] control_rsp_control_id;
  logic [(16)-1:0] control_rsp_status;
  logic [(1)-1:0] control_rsp_committed;
  logic [(1)-1:0] control_rsp_cleanup_done;
  logic [(8)-1:0] control_rsp_object_state;
  modport caller (
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
    output req_invocation_id,
    output req_action,
    output req_lease_token,
    output req_algorithm,
    output req_operation,
    output req_template,
    output req_policy_epoch,
    output req_key_source,
    output req_key_ref,
    output req_key_epoch,
    output req_key_length,
    output req_tag_length,
    output req_part_count,
    output req_message_parts,
    output req_iteration,
    output req_result_sink_ref,
    input rsp_valid,
    output rsp_ready,
    input rsp_owner_id,
    input rsp_instance_id,
    input rsp_epoch,
    input rsp_task_id,
    input rsp_request_seq,
    input rsp_context_id,
    input rsp_generation,
    input rsp_invocation_id,
    input rsp_action,
    input rsp_lease_token,
    input rsp_status,
    input rsp_auth_valid,
    input rsp_auth_ok,
    input rsp_result_ref,
    input rsp_result_epoch,
    input rsp_result_bytes,
    input rsp_consumed_public,
    input rsp_consumed_secret,
    input rsp_produced,
    input rsp_cleanup_done,
    input rsp_object_state,
    output public_data_valid,
    input public_data_ready,
    output public_data_owner_id,
    output public_data_instance_id,
    output public_data_epoch,
    output public_data_task_id,
    output public_data_request_seq,
    output public_data_context_id,
    output public_data_generation,
    output public_data_invocation_id,
    output public_data_lease_token,
    output public_data_source,
    output public_data_offset,
    output public_data_data,
    output public_data_keep,
    output public_data_last,
    output control_req_valid,
    input control_req_ready,
    output control_req_owner_id,
    output control_req_instance_id,
    output control_req_epoch,
    output control_req_task_id,
    output control_req_request_seq,
    output control_req_context_id,
    output control_req_generation,
    output control_req_invocation_id,
    output control_req_lease_token,
    output control_req_action,
    output control_req_control_id,
    input control_rsp_valid,
    output control_rsp_ready,
    input control_rsp_owner_id,
    input control_rsp_instance_id,
    input control_rsp_epoch,
    input control_rsp_task_id,
    input control_rsp_request_seq,
    input control_rsp_context_id,
    input control_rsp_generation,
    input control_rsp_invocation_id,
    input control_rsp_lease_token,
    input control_rsp_control_id,
    input control_rsp_status,
    input control_rsp_committed,
    input control_rsp_cleanup_done,
    input control_rsp_object_state
  );
  modport callee (
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
    input req_invocation_id,
    input req_action,
    input req_lease_token,
    input req_algorithm,
    input req_operation,
    input req_template,
    input req_policy_epoch,
    input req_key_source,
    input req_key_ref,
    input req_key_epoch,
    input req_key_length,
    input req_tag_length,
    input req_part_count,
    input req_message_parts,
    input req_iteration,
    input req_result_sink_ref,
    output rsp_valid,
    input rsp_ready,
    output rsp_owner_id,
    output rsp_instance_id,
    output rsp_epoch,
    output rsp_task_id,
    output rsp_request_seq,
    output rsp_context_id,
    output rsp_generation,
    output rsp_invocation_id,
    output rsp_action,
    output rsp_lease_token,
    output rsp_status,
    output rsp_auth_valid,
    output rsp_auth_ok,
    output rsp_result_ref,
    output rsp_result_epoch,
    output rsp_result_bytes,
    output rsp_consumed_public,
    output rsp_consumed_secret,
    output rsp_produced,
    output rsp_cleanup_done,
    output rsp_object_state,
    input public_data_valid,
    output public_data_ready,
    input public_data_owner_id,
    input public_data_instance_id,
    input public_data_epoch,
    input public_data_task_id,
    input public_data_request_seq,
    input public_data_context_id,
    input public_data_generation,
    input public_data_invocation_id,
    input public_data_lease_token,
    input public_data_source,
    input public_data_offset,
    input public_data_data,
    input public_data_keep,
    input public_data_last,
    input control_req_valid,
    output control_req_ready,
    input control_req_owner_id,
    input control_req_instance_id,
    input control_req_epoch,
    input control_req_task_id,
    input control_req_request_seq,
    input control_req_context_id,
    input control_req_generation,
    input control_req_invocation_id,
    input control_req_lease_token,
    input control_req_action,
    input control_req_control_id,
    output control_rsp_valid,
    input control_rsp_ready,
    output control_rsp_owner_id,
    output control_rsp_instance_id,
    output control_rsp_epoch,
    output control_rsp_task_id,
    output control_rsp_request_seq,
    output control_rsp_context_id,
    output control_rsp_generation,
    output control_rsp_invocation_id,
    output control_rsp_lease_token,
    output control_rsp_control_id,
    output control_rsp_status,
    output control_rsp_committed,
    output control_rsp_cleanup_done,
    output control_rsp_object_state
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
    input req_invocation_id,
    input req_action,
    input req_lease_token,
    input req_algorithm,
    input req_operation,
    input req_template,
    input req_policy_epoch,
    input req_key_source,
    input req_key_ref,
    input req_key_epoch,
    input req_key_length,
    input req_tag_length,
    input req_part_count,
    input req_message_parts,
    input req_iteration,
    input req_result_sink_ref,
    input rsp_valid,
    input rsp_ready,
    input rsp_owner_id,
    input rsp_instance_id,
    input rsp_epoch,
    input rsp_task_id,
    input rsp_request_seq,
    input rsp_context_id,
    input rsp_generation,
    input rsp_invocation_id,
    input rsp_action,
    input rsp_lease_token,
    input rsp_status,
    input rsp_auth_valid,
    input rsp_auth_ok,
    input rsp_result_ref,
    input rsp_result_epoch,
    input rsp_result_bytes,
    input rsp_consumed_public,
    input rsp_consumed_secret,
    input rsp_produced,
    input rsp_cleanup_done,
    input rsp_object_state,
    input public_data_valid,
    input public_data_ready,
    input public_data_owner_id,
    input public_data_instance_id,
    input public_data_epoch,
    input public_data_task_id,
    input public_data_request_seq,
    input public_data_context_id,
    input public_data_generation,
    input public_data_invocation_id,
    input public_data_lease_token,
    input public_data_source,
    input public_data_offset,
    input public_data_data,
    input public_data_keep,
    input public_data_last,
    input control_req_valid,
    input control_req_ready,
    input control_req_owner_id,
    input control_req_instance_id,
    input control_req_epoch,
    input control_req_task_id,
    input control_req_request_seq,
    input control_req_context_id,
    input control_req_generation,
    input control_req_invocation_id,
    input control_req_lease_token,
    input control_req_action,
    input control_req_control_id,
    input control_rsp_valid,
    input control_rsp_ready,
    input control_rsp_owner_id,
    input control_rsp_instance_id,
    input control_rsp_epoch,
    input control_rsp_task_id,
    input control_rsp_request_seq,
    input control_rsp_context_id,
    input control_rsp_generation,
    input control_rsp_invocation_id,
    input control_rsp_lease_token,
    input control_rsp_control_id,
    input control_rsp_status,
    input control_rsp_committed,
    input control_rsp_cleanup_done,
    input control_rsp_object_state
  );
endinterface : aix_crypto_mac_call_if
