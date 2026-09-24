// SPDX-License-Identifier: Apache-2.0
// Generated from the interface contract. Do not edit.

interface aix_cci_if #(parameter int unsigned DATA_W = 128)(
  input logic clk,
  input logic reset_n
);
  logic [(1)-1:0] cmd_valid;
  logic [(1)-1:0] cmd_ready;
  logic [(32)-1:0] cmd_owner_id;
  logic [(16)-1:0] cmd_instance_id;
  logic [(32)-1:0] cmd_epoch;
  logic [(32)-1:0] cmd_task_id;
  logic [(64)-1:0] cmd_request_seq;
  logic [(16)-1:0] cmd_context_id;
  logic [(32)-1:0] cmd_generation;
  logic [(16)-1:0] cmd_operation;
  logic [(8)-1:0] cmd_mode;
  logic [(8)-1:0] cmd_direction;
  logic [(8)-1:0] cmd_action;
  logic [(1)-1:0] cmd_inherit;
  logic [(32)-1:0] cmd_policy_epoch;
  logic [(8)-1:0] cmd_key_count;
  logic [(32)-1:0] cmd_key_bits;
  logic [(416)-1:0] cmd_key_bindings;
  logic [(64)-1:0] cmd_out_len;
  logic [(32)-1:0] cmd_tag_len;
  logic [(1)-1:0] cmd_message_total_known;
  logic [(64)-1:0] cmd_message_total_len;
  logic [(1)-1:0] cmd_aad_total_known;
  logic [(64)-1:0] cmd_aad_total_len;
  logic [(8)-1:0] cmd_segment_count;
  logic [(1456)-1:0] cmd_segments;
  logic [(32)-1:0] cmd_initial_counter;
  logic [(1)-1:0] cmd_counter_present;
  logic [(1)-1:0] din_valid;
  logic [(1)-1:0] din_ready;
  logic [(32)-1:0] din_owner_id;
  logic [(16)-1:0] din_instance_id;
  logic [(32)-1:0] din_epoch;
  logic [(32)-1:0] din_task_id;
  logic [(64)-1:0] din_request_seq;
  logic [(16)-1:0] din_context_id;
  logic [(32)-1:0] din_generation;
  logic [(16)-1:0] din_segment_index;
  logic [(DATA_W)-1:0] din_data;
  logic [(DATA_W/8)-1:0] din_keep;
  logic [(1)-1:0] din_last;
  logic [(1)-1:0] dout_valid;
  logic [(1)-1:0] dout_ready;
  logic [(32)-1:0] dout_owner_id;
  logic [(16)-1:0] dout_instance_id;
  logic [(32)-1:0] dout_epoch;
  logic [(32)-1:0] dout_task_id;
  logic [(64)-1:0] dout_request_seq;
  logic [(16)-1:0] dout_context_id;
  logic [(32)-1:0] dout_generation;
  logic [(16)-1:0] dout_segment_index;
  logic [(8)-1:0] dout_segment_kind;
  logic [(DATA_W)-1:0] dout_data;
  logic [(DATA_W/8)-1:0] dout_keep;
  logic [(1)-1:0] dout_last;
  logic [(1)-1:0] dout_provisional;
  logic [(1)-1:0] dout_secret;
  logic [(1)-1:0] cpl_valid;
  logic [(1)-1:0] cpl_ready;
  logic [(32)-1:0] cpl_owner_id;
  logic [(16)-1:0] cpl_instance_id;
  logic [(32)-1:0] cpl_epoch;
  logic [(32)-1:0] cpl_task_id;
  logic [(64)-1:0] cpl_request_seq;
  logic [(16)-1:0] cpl_context_id;
  logic [(32)-1:0] cpl_generation;
  logic [(16)-1:0] cpl_status;
  logic [(16)-1:0] cpl_detail;
  logic [(1)-1:0] cpl_auth_valid;
  logic [(1)-1:0] cpl_auth_ok;
  logic [(64)-1:0] cpl_consumed;
  logic [(64)-1:0] cpl_produced;
  logic [(64)-1:0] cpl_delivered;
  logic [(1)-1:0] cpl_context_alive;
  logic [(1)-1:0] cpl_cleanup_done;
  logic [(64)-1:0] cpl_result_ref;
  logic [(64)-1:0] cpl_secret_result_bytes;
  logic [(64)-1:0] cpl_replay_bytes;
  logic [(1)-1:0] mgmt_req_valid;
  logic [(1)-1:0] mgmt_req_ready;
  logic [(32)-1:0] mgmt_req_owner_id;
  logic [(16)-1:0] mgmt_req_instance_id;
  logic [(32)-1:0] mgmt_req_epoch;
  logic [(32)-1:0] mgmt_req_task_id;
  logic [(64)-1:0] mgmt_req_request_seq;
  logic [(16)-1:0] mgmt_req_context_id;
  logic [(32)-1:0] mgmt_req_generation;
  logic [(32)-1:0] mgmt_req_request_id;
  logic [(8)-1:0] mgmt_req_operation;
  logic [(8)-1:0] mgmt_req_scope;
  logic [(64)-1:0] mgmt_req_key_ref;
  logic [(32)-1:0] mgmt_req_key_epoch;
  logic [(1)-1:0] mgmt_rsp_valid;
  logic [(1)-1:0] mgmt_rsp_ready;
  logic [(32)-1:0] mgmt_rsp_owner_id;
  logic [(16)-1:0] mgmt_rsp_instance_id;
  logic [(32)-1:0] mgmt_rsp_epoch;
  logic [(32)-1:0] mgmt_rsp_task_id;
  logic [(64)-1:0] mgmt_rsp_request_seq;
  logic [(16)-1:0] mgmt_rsp_context_id;
  logic [(32)-1:0] mgmt_rsp_generation;
  logic [(32)-1:0] mgmt_rsp_request_id;
  logic [(16)-1:0] mgmt_rsp_status;
  logic [(1)-1:0] mgmt_rsp_drain_done;
  logic [(1)-1:0] mgmt_rsp_cleanup_done;
  logic [(1)-1:0] mgmt_rsp_committed;
  logic [(1)-1:0] cap_req_valid;
  logic [(1)-1:0] cap_req_ready;
  logic [(32)-1:0] cap_req_request_id;
  logic [(32)-1:0] cap_req_word_index;
  logic [(1)-1:0] cap_rsp_valid;
  logic [(1)-1:0] cap_rsp_ready;
  logic [(32)-1:0] cap_rsp_request_id;
  logic [(32)-1:0] cap_rsp_word_index;
  logic [(16)-1:0] cap_rsp_status;
  logic [(32)-1:0] cap_rsp_data;
  logic [(1)-1:0] cap_rsp_last;
  modport client (
    input clk,
    input reset_n,
    output cmd_valid,
    input cmd_ready,
    output cmd_owner_id,
    output cmd_instance_id,
    output cmd_epoch,
    output cmd_task_id,
    output cmd_request_seq,
    output cmd_context_id,
    output cmd_generation,
    output cmd_operation,
    output cmd_mode,
    output cmd_direction,
    output cmd_action,
    output cmd_inherit,
    output cmd_policy_epoch,
    output cmd_key_count,
    output cmd_key_bits,
    output cmd_key_bindings,
    output cmd_out_len,
    output cmd_tag_len,
    output cmd_message_total_known,
    output cmd_message_total_len,
    output cmd_aad_total_known,
    output cmd_aad_total_len,
    output cmd_segment_count,
    output cmd_segments,
    output cmd_initial_counter,
    output cmd_counter_present,
    output din_valid,
    input din_ready,
    output din_owner_id,
    output din_instance_id,
    output din_epoch,
    output din_task_id,
    output din_request_seq,
    output din_context_id,
    output din_generation,
    output din_segment_index,
    output din_data,
    output din_keep,
    output din_last,
    input dout_valid,
    output dout_ready,
    input dout_owner_id,
    input dout_instance_id,
    input dout_epoch,
    input dout_task_id,
    input dout_request_seq,
    input dout_context_id,
    input dout_generation,
    input dout_segment_index,
    input dout_segment_kind,
    input dout_data,
    input dout_keep,
    input dout_last,
    input dout_provisional,
    input dout_secret,
    input cpl_valid,
    output cpl_ready,
    input cpl_owner_id,
    input cpl_instance_id,
    input cpl_epoch,
    input cpl_task_id,
    input cpl_request_seq,
    input cpl_context_id,
    input cpl_generation,
    input cpl_status,
    input cpl_detail,
    input cpl_auth_valid,
    input cpl_auth_ok,
    input cpl_consumed,
    input cpl_produced,
    input cpl_delivered,
    input cpl_context_alive,
    input cpl_cleanup_done,
    input cpl_result_ref,
    input cpl_secret_result_bytes,
    input cpl_replay_bytes,
    output mgmt_req_valid,
    input mgmt_req_ready,
    output mgmt_req_owner_id,
    output mgmt_req_instance_id,
    output mgmt_req_epoch,
    output mgmt_req_task_id,
    output mgmt_req_request_seq,
    output mgmt_req_context_id,
    output mgmt_req_generation,
    output mgmt_req_request_id,
    output mgmt_req_operation,
    output mgmt_req_scope,
    output mgmt_req_key_ref,
    output mgmt_req_key_epoch,
    input mgmt_rsp_valid,
    output mgmt_rsp_ready,
    input mgmt_rsp_owner_id,
    input mgmt_rsp_instance_id,
    input mgmt_rsp_epoch,
    input mgmt_rsp_task_id,
    input mgmt_rsp_request_seq,
    input mgmt_rsp_context_id,
    input mgmt_rsp_generation,
    input mgmt_rsp_request_id,
    input mgmt_rsp_status,
    input mgmt_rsp_drain_done,
    input mgmt_rsp_cleanup_done,
    input mgmt_rsp_committed,
    output cap_req_valid,
    input cap_req_ready,
    output cap_req_request_id,
    output cap_req_word_index,
    input cap_rsp_valid,
    output cap_rsp_ready,
    input cap_rsp_request_id,
    input cap_rsp_word_index,
    input cap_rsp_status,
    input cap_rsp_data,
    input cap_rsp_last
  );
  modport component (
    input clk,
    input reset_n,
    input cmd_valid,
    output cmd_ready,
    input cmd_owner_id,
    input cmd_instance_id,
    input cmd_epoch,
    input cmd_task_id,
    input cmd_request_seq,
    input cmd_context_id,
    input cmd_generation,
    input cmd_operation,
    input cmd_mode,
    input cmd_direction,
    input cmd_action,
    input cmd_inherit,
    input cmd_policy_epoch,
    input cmd_key_count,
    input cmd_key_bits,
    input cmd_key_bindings,
    input cmd_out_len,
    input cmd_tag_len,
    input cmd_message_total_known,
    input cmd_message_total_len,
    input cmd_aad_total_known,
    input cmd_aad_total_len,
    input cmd_segment_count,
    input cmd_segments,
    input cmd_initial_counter,
    input cmd_counter_present,
    input din_valid,
    output din_ready,
    input din_owner_id,
    input din_instance_id,
    input din_epoch,
    input din_task_id,
    input din_request_seq,
    input din_context_id,
    input din_generation,
    input din_segment_index,
    input din_data,
    input din_keep,
    input din_last,
    output dout_valid,
    input dout_ready,
    output dout_owner_id,
    output dout_instance_id,
    output dout_epoch,
    output dout_task_id,
    output dout_request_seq,
    output dout_context_id,
    output dout_generation,
    output dout_segment_index,
    output dout_segment_kind,
    output dout_data,
    output dout_keep,
    output dout_last,
    output dout_provisional,
    output dout_secret,
    output cpl_valid,
    input cpl_ready,
    output cpl_owner_id,
    output cpl_instance_id,
    output cpl_epoch,
    output cpl_task_id,
    output cpl_request_seq,
    output cpl_context_id,
    output cpl_generation,
    output cpl_status,
    output cpl_detail,
    output cpl_auth_valid,
    output cpl_auth_ok,
    output cpl_consumed,
    output cpl_produced,
    output cpl_delivered,
    output cpl_context_alive,
    output cpl_cleanup_done,
    output cpl_result_ref,
    output cpl_secret_result_bytes,
    output cpl_replay_bytes,
    input mgmt_req_valid,
    output mgmt_req_ready,
    input mgmt_req_owner_id,
    input mgmt_req_instance_id,
    input mgmt_req_epoch,
    input mgmt_req_task_id,
    input mgmt_req_request_seq,
    input mgmt_req_context_id,
    input mgmt_req_generation,
    input mgmt_req_request_id,
    input mgmt_req_operation,
    input mgmt_req_scope,
    input mgmt_req_key_ref,
    input mgmt_req_key_epoch,
    output mgmt_rsp_valid,
    input mgmt_rsp_ready,
    output mgmt_rsp_owner_id,
    output mgmt_rsp_instance_id,
    output mgmt_rsp_epoch,
    output mgmt_rsp_task_id,
    output mgmt_rsp_request_seq,
    output mgmt_rsp_context_id,
    output mgmt_rsp_generation,
    output mgmt_rsp_request_id,
    output mgmt_rsp_status,
    output mgmt_rsp_drain_done,
    output mgmt_rsp_cleanup_done,
    output mgmt_rsp_committed,
    input cap_req_valid,
    output cap_req_ready,
    input cap_req_request_id,
    input cap_req_word_index,
    output cap_rsp_valid,
    input cap_rsp_ready,
    output cap_rsp_request_id,
    output cap_rsp_word_index,
    output cap_rsp_status,
    output cap_rsp_data,
    output cap_rsp_last
  );
  modport monitor (
    input clk,
    input reset_n,
    input cmd_valid,
    input cmd_ready,
    input cmd_owner_id,
    input cmd_instance_id,
    input cmd_epoch,
    input cmd_task_id,
    input cmd_request_seq,
    input cmd_context_id,
    input cmd_generation,
    input cmd_operation,
    input cmd_mode,
    input cmd_direction,
    input cmd_action,
    input cmd_inherit,
    input cmd_policy_epoch,
    input cmd_key_count,
    input cmd_key_bits,
    input cmd_key_bindings,
    input cmd_out_len,
    input cmd_tag_len,
    input cmd_message_total_known,
    input cmd_message_total_len,
    input cmd_aad_total_known,
    input cmd_aad_total_len,
    input cmd_segment_count,
    input cmd_segments,
    input cmd_initial_counter,
    input cmd_counter_present,
    input din_valid,
    input din_ready,
    input din_owner_id,
    input din_instance_id,
    input din_epoch,
    input din_task_id,
    input din_request_seq,
    input din_context_id,
    input din_generation,
    input din_segment_index,
    input din_data,
    input din_keep,
    input din_last,
    input dout_valid,
    input dout_ready,
    input dout_owner_id,
    input dout_instance_id,
    input dout_epoch,
    input dout_task_id,
    input dout_request_seq,
    input dout_context_id,
    input dout_generation,
    input dout_segment_index,
    input dout_segment_kind,
    input dout_data,
    input dout_keep,
    input dout_last,
    input dout_provisional,
    input dout_secret,
    input cpl_valid,
    input cpl_ready,
    input cpl_owner_id,
    input cpl_instance_id,
    input cpl_epoch,
    input cpl_task_id,
    input cpl_request_seq,
    input cpl_context_id,
    input cpl_generation,
    input cpl_status,
    input cpl_detail,
    input cpl_auth_valid,
    input cpl_auth_ok,
    input cpl_consumed,
    input cpl_produced,
    input cpl_delivered,
    input cpl_context_alive,
    input cpl_cleanup_done,
    input cpl_result_ref,
    input cpl_secret_result_bytes,
    input cpl_replay_bytes,
    input mgmt_req_valid,
    input mgmt_req_ready,
    input mgmt_req_owner_id,
    input mgmt_req_instance_id,
    input mgmt_req_epoch,
    input mgmt_req_task_id,
    input mgmt_req_request_seq,
    input mgmt_req_context_id,
    input mgmt_req_generation,
    input mgmt_req_request_id,
    input mgmt_req_operation,
    input mgmt_req_scope,
    input mgmt_req_key_ref,
    input mgmt_req_key_epoch,
    input mgmt_rsp_valid,
    input mgmt_rsp_ready,
    input mgmt_rsp_owner_id,
    input mgmt_rsp_instance_id,
    input mgmt_rsp_epoch,
    input mgmt_rsp_task_id,
    input mgmt_rsp_request_seq,
    input mgmt_rsp_context_id,
    input mgmt_rsp_generation,
    input mgmt_rsp_request_id,
    input mgmt_rsp_status,
    input mgmt_rsp_drain_done,
    input mgmt_rsp_cleanup_done,
    input mgmt_rsp_committed,
    input cap_req_valid,
    input cap_req_ready,
    input cap_req_request_id,
    input cap_req_word_index,
    input cap_rsp_valid,
    input cap_rsp_ready,
    input cap_rsp_request_id,
    input cap_rsp_word_index,
    input cap_rsp_status,
    input cap_rsp_data,
    input cap_rsp_last
  );
endinterface : aix_cci_if
