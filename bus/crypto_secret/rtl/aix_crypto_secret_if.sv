// SPDX-License-Identifier: Apache-2.0
// Generated from the interface contract. Do not edit.

interface aix_crypto_secret_if #(parameter int unsigned DATA_W = 128)(
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
  logic [(16)-1:0] req_service_version;
  logic [(64)-1:0] req_request_id;
  logic [(32)-1:0] req_policy_epoch;
  logic [(32)-1:0] req_key_epoch;
  logic [(8)-1:0] req_role;
  logic [(64)-1:0] req_object_ref;
  logic [(64)-1:0] req_offset;
  logic [(64)-1:0] req_length;
  logic [(16)-1:0] req_operation;
  logic [(8)-1:0] req_mode;
  logic [(16)-1:0] req_use;
  logic [(64)-1:0] req_result_sink_ref;
  logic [(64)-1:0] req_usage_amount;
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
  logic [(64)-1:0] rsp_object_ref;
  logic [(32)-1:0] rsp_object_epoch;
  logic [(64)-1:0] rsp_total_length;
  logic [(64)-1:0] rsp_offset;
  logic [(32)-1:0] rsp_fragment_length;
  logic [(1)-1:0] rsp_end;
  logic [(8)-1:0] rsp_object_state;
  logic [(1)-1:0] write_valid;
  logic [(1)-1:0] write_ready;
  logic [(32)-1:0] write_owner_id;
  logic [(16)-1:0] write_instance_id;
  logic [(32)-1:0] write_epoch;
  logic [(32)-1:0] write_task_id;
  logic [(64)-1:0] write_request_seq;
  logic [(16)-1:0] write_context_id;
  logic [(32)-1:0] write_generation;
  logic [(64)-1:0] write_request_id;
  logic [(64)-1:0] write_offset;
  logic [(DATA_W)-1:0] write_data;
  logic [(DATA_W/8)-1:0] write_keep;
  logic [(1)-1:0] write_last;
  logic [(1)-1:0] read_valid;
  logic [(1)-1:0] read_ready;
  logic [(32)-1:0] read_owner_id;
  logic [(16)-1:0] read_instance_id;
  logic [(32)-1:0] read_epoch;
  logic [(32)-1:0] read_task_id;
  logic [(64)-1:0] read_request_seq;
  logic [(16)-1:0] read_context_id;
  logic [(32)-1:0] read_generation;
  logic [(64)-1:0] read_request_id;
  logic [(64)-1:0] read_offset;
  logic [(DATA_W)-1:0] read_data;
  logic [(DATA_W/8)-1:0] read_keep;
  logic [(1)-1:0] read_last;
  logic [(1)-1:0] control_req_valid;
  logic [(1)-1:0] control_req_ready;
  logic [(32)-1:0] control_req_owner_id;
  logic [(16)-1:0] control_req_instance_id;
  logic [(32)-1:0] control_req_epoch;
  logic [(32)-1:0] control_req_task_id;
  logic [(64)-1:0] control_req_request_seq;
  logic [(16)-1:0] control_req_context_id;
  logic [(32)-1:0] control_req_generation;
  logic [(16)-1:0] control_req_service_version;
  logic [(64)-1:0] control_req_request_id;
  logic [(32)-1:0] control_req_policy_epoch;
  logic [(32)-1:0] control_req_key_epoch;
  logic [(8)-1:0] control_req_role;
  logic [(64)-1:0] control_req_object_ref;
  logic [(64)-1:0] control_req_offset;
  logic [(64)-1:0] control_req_length;
  logic [(16)-1:0] control_req_operation;
  logic [(8)-1:0] control_req_mode;
  logic [(16)-1:0] control_req_use;
  logic [(64)-1:0] control_req_result_sink_ref;
  logic [(64)-1:0] control_req_usage_amount;
  logic [(1)-1:0] control_rsp_valid;
  logic [(1)-1:0] control_rsp_ready;
  logic [(32)-1:0] control_rsp_owner_id;
  logic [(16)-1:0] control_rsp_instance_id;
  logic [(32)-1:0] control_rsp_epoch;
  logic [(32)-1:0] control_rsp_task_id;
  logic [(64)-1:0] control_rsp_request_seq;
  logic [(16)-1:0] control_rsp_context_id;
  logic [(32)-1:0] control_rsp_generation;
  logic [(64)-1:0] control_rsp_request_id;
  logic [(16)-1:0] control_rsp_status;
  logic [(8)-1:0] control_rsp_object_state;
  logic [(1)-1:0] control_rsp_cleanup_done;
  modport requester (
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
    output req_service_version,
    output req_request_id,
    output req_policy_epoch,
    output req_key_epoch,
    output req_role,
    output req_object_ref,
    output req_offset,
    output req_length,
    output req_operation,
    output req_mode,
    output req_use,
    output req_result_sink_ref,
    output req_usage_amount,
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
    input rsp_object_ref,
    input rsp_object_epoch,
    input rsp_total_length,
    input rsp_offset,
    input rsp_fragment_length,
    input rsp_end,
    input rsp_object_state,
    output write_valid,
    input write_ready,
    output write_owner_id,
    output write_instance_id,
    output write_epoch,
    output write_task_id,
    output write_request_seq,
    output write_context_id,
    output write_generation,
    output write_request_id,
    output write_offset,
    output write_data,
    output write_keep,
    output write_last,
    input read_valid,
    output read_ready,
    input read_owner_id,
    input read_instance_id,
    input read_epoch,
    input read_task_id,
    input read_request_seq,
    input read_context_id,
    input read_generation,
    input read_request_id,
    input read_offset,
    input read_data,
    input read_keep,
    input read_last,
    output control_req_valid,
    input control_req_ready,
    output control_req_owner_id,
    output control_req_instance_id,
    output control_req_epoch,
    output control_req_task_id,
    output control_req_request_seq,
    output control_req_context_id,
    output control_req_generation,
    output control_req_service_version,
    output control_req_request_id,
    output control_req_policy_epoch,
    output control_req_key_epoch,
    output control_req_role,
    output control_req_object_ref,
    output control_req_offset,
    output control_req_length,
    output control_req_operation,
    output control_req_mode,
    output control_req_use,
    output control_req_result_sink_ref,
    output control_req_usage_amount,
    input control_rsp_valid,
    output control_rsp_ready,
    input control_rsp_owner_id,
    input control_rsp_instance_id,
    input control_rsp_epoch,
    input control_rsp_task_id,
    input control_rsp_request_seq,
    input control_rsp_context_id,
    input control_rsp_generation,
    input control_rsp_request_id,
    input control_rsp_status,
    input control_rsp_object_state,
    input control_rsp_cleanup_done
  );
  modport service (
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
    input req_service_version,
    input req_request_id,
    input req_policy_epoch,
    input req_key_epoch,
    input req_role,
    input req_object_ref,
    input req_offset,
    input req_length,
    input req_operation,
    input req_mode,
    input req_use,
    input req_result_sink_ref,
    input req_usage_amount,
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
    output rsp_object_ref,
    output rsp_object_epoch,
    output rsp_total_length,
    output rsp_offset,
    output rsp_fragment_length,
    output rsp_end,
    output rsp_object_state,
    input write_valid,
    output write_ready,
    input write_owner_id,
    input write_instance_id,
    input write_epoch,
    input write_task_id,
    input write_request_seq,
    input write_context_id,
    input write_generation,
    input write_request_id,
    input write_offset,
    input write_data,
    input write_keep,
    input write_last,
    output read_valid,
    input read_ready,
    output read_owner_id,
    output read_instance_id,
    output read_epoch,
    output read_task_id,
    output read_request_seq,
    output read_context_id,
    output read_generation,
    output read_request_id,
    output read_offset,
    output read_data,
    output read_keep,
    output read_last,
    input control_req_valid,
    output control_req_ready,
    input control_req_owner_id,
    input control_req_instance_id,
    input control_req_epoch,
    input control_req_task_id,
    input control_req_request_seq,
    input control_req_context_id,
    input control_req_generation,
    input control_req_service_version,
    input control_req_request_id,
    input control_req_policy_epoch,
    input control_req_key_epoch,
    input control_req_role,
    input control_req_object_ref,
    input control_req_offset,
    input control_req_length,
    input control_req_operation,
    input control_req_mode,
    input control_req_use,
    input control_req_result_sink_ref,
    input control_req_usage_amount,
    output control_rsp_valid,
    input control_rsp_ready,
    output control_rsp_owner_id,
    output control_rsp_instance_id,
    output control_rsp_epoch,
    output control_rsp_task_id,
    output control_rsp_request_seq,
    output control_rsp_context_id,
    output control_rsp_generation,
    output control_rsp_request_id,
    output control_rsp_status,
    output control_rsp_object_state,
    output control_rsp_cleanup_done
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
    input req_service_version,
    input req_request_id,
    input req_policy_epoch,
    input req_key_epoch,
    input req_role,
    input req_object_ref,
    input req_offset,
    input req_length,
    input req_operation,
    input req_mode,
    input req_use,
    input req_result_sink_ref,
    input req_usage_amount,
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
    input rsp_object_ref,
    input rsp_object_epoch,
    input rsp_total_length,
    input rsp_offset,
    input rsp_fragment_length,
    input rsp_end,
    input rsp_object_state,
    input write_valid,
    input write_ready,
    input write_owner_id,
    input write_instance_id,
    input write_epoch,
    input write_task_id,
    input write_request_seq,
    input write_context_id,
    input write_generation,
    input write_request_id,
    input write_offset,
    input write_data,
    input write_keep,
    input write_last,
    input read_valid,
    input read_ready,
    input read_owner_id,
    input read_instance_id,
    input read_epoch,
    input read_task_id,
    input read_request_seq,
    input read_context_id,
    input read_generation,
    input read_request_id,
    input read_offset,
    input read_data,
    input read_keep,
    input read_last,
    input control_req_valid,
    input control_req_ready,
    input control_req_owner_id,
    input control_req_instance_id,
    input control_req_epoch,
    input control_req_task_id,
    input control_req_request_seq,
    input control_req_context_id,
    input control_req_generation,
    input control_req_service_version,
    input control_req_request_id,
    input control_req_policy_epoch,
    input control_req_key_epoch,
    input control_req_role,
    input control_req_object_ref,
    input control_req_offset,
    input control_req_length,
    input control_req_operation,
    input control_req_mode,
    input control_req_use,
    input control_req_result_sink_ref,
    input control_req_usage_amount,
    input control_rsp_valid,
    input control_rsp_ready,
    input control_rsp_owner_id,
    input control_rsp_instance_id,
    input control_rsp_epoch,
    input control_rsp_task_id,
    input control_rsp_request_seq,
    input control_rsp_context_id,
    input control_rsp_generation,
    input control_rsp_request_id,
    input control_rsp_status,
    input control_rsp_object_state,
    input control_rsp_cleanup_done
  );
endinterface : aix_crypto_secret_if
