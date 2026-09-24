// SPDX-License-Identifier: Apache-2.0
// Generated from the interface contract. Do not edit.

interface aix_crypto_staging_if #(parameter int unsigned DATA_W = 128)(
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
  logic [(8)-1:0] req_operation;
  logic [(64)-1:0] req_staging_ref;
  logic [(64)-1:0] req_length;
  logic [(32)-1:0] req_policy_epoch;
  logic [(1)-1:0] req_auth_valid;
  logic [(1)-1:0] req_auth_ok;
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
  logic [(64)-1:0] rsp_staging_ref;
  logic [(64)-1:0] rsp_reserved_bytes;
  logic [(64)-1:0] rsp_written_bytes;
  logic [(8)-1:0] rsp_state;
  logic [(1)-1:0] rsp_cleanup_done;
  logic [(1)-1:0] write_valid;
  logic [(1)-1:0] write_ready;
  logic [(32)-1:0] write_owner_id;
  logic [(16)-1:0] write_instance_id;
  logic [(32)-1:0] write_epoch;
  logic [(32)-1:0] write_task_id;
  logic [(64)-1:0] write_request_seq;
  logic [(16)-1:0] write_context_id;
  logic [(32)-1:0] write_generation;
  logic [(64)-1:0] write_staging_ref;
  logic [(64)-1:0] write_offset;
  logic [(DATA_W)-1:0] write_data;
  logic [(DATA_W/8)-1:0] write_keep;
  logic [(1)-1:0] write_last;
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
  logic [(8)-1:0] control_req_operation;
  logic [(64)-1:0] control_req_staging_ref;
  logic [(64)-1:0] control_req_length;
  logic [(32)-1:0] control_req_policy_epoch;
  logic [(1)-1:0] control_req_auth_valid;
  logic [(1)-1:0] control_req_auth_ok;
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
  logic [(8)-1:0] control_rsp_state;
  logic [(1)-1:0] control_rsp_cleanup_done;
  modport shell (
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
    output req_operation,
    output req_staging_ref,
    output req_length,
    output req_policy_epoch,
    output req_auth_valid,
    output req_auth_ok,
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
    input rsp_staging_ref,
    input rsp_reserved_bytes,
    input rsp_written_bytes,
    input rsp_state,
    input rsp_cleanup_done,
    output write_valid,
    input write_ready,
    output write_owner_id,
    output write_instance_id,
    output write_epoch,
    output write_task_id,
    output write_request_seq,
    output write_context_id,
    output write_generation,
    output write_staging_ref,
    output write_offset,
    output write_data,
    output write_keep,
    output write_last,
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
    output control_req_operation,
    output control_req_staging_ref,
    output control_req_length,
    output control_req_policy_epoch,
    output control_req_auth_valid,
    output control_req_auth_ok,
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
    input control_rsp_state,
    input control_rsp_cleanup_done
  );
  modport staging (
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
    input req_operation,
    input req_staging_ref,
    input req_length,
    input req_policy_epoch,
    input req_auth_valid,
    input req_auth_ok,
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
    output rsp_staging_ref,
    output rsp_reserved_bytes,
    output rsp_written_bytes,
    output rsp_state,
    output rsp_cleanup_done,
    input write_valid,
    output write_ready,
    input write_owner_id,
    input write_instance_id,
    input write_epoch,
    input write_task_id,
    input write_request_seq,
    input write_context_id,
    input write_generation,
    input write_staging_ref,
    input write_offset,
    input write_data,
    input write_keep,
    input write_last,
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
    input control_req_operation,
    input control_req_staging_ref,
    input control_req_length,
    input control_req_policy_epoch,
    input control_req_auth_valid,
    input control_req_auth_ok,
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
    output control_rsp_state,
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
    input req_operation,
    input req_staging_ref,
    input req_length,
    input req_policy_epoch,
    input req_auth_valid,
    input req_auth_ok,
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
    input rsp_staging_ref,
    input rsp_reserved_bytes,
    input rsp_written_bytes,
    input rsp_state,
    input rsp_cleanup_done,
    input write_valid,
    input write_ready,
    input write_owner_id,
    input write_instance_id,
    input write_epoch,
    input write_task_id,
    input write_request_seq,
    input write_context_id,
    input write_generation,
    input write_staging_ref,
    input write_offset,
    input write_data,
    input write_keep,
    input write_last,
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
    input control_req_operation,
    input control_req_staging_ref,
    input control_req_length,
    input control_req_policy_epoch,
    input control_req_auth_valid,
    input control_req_auth_ok,
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
    input control_rsp_state,
    input control_rsp_cleanup_done
  );
endinterface : aix_crypto_staging_if
