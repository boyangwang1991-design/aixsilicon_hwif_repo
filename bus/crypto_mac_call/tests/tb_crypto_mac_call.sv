// SPDX-License-Identifier: Apache-2.0
`default_nettype none
module tb_crypto_mac_call;
  parameter int unsigned DATA_W=128;
  logic clk=0,reset_n=0;
  aix_crypto_mac_call_if #(.DATA_W(DATA_W)) link(clk,reset_n);
  always #5 clk=~clk;
  initial begin
    link.req_valid=0;link.req_ready=0;link.public_data_valid=0;
    link.req_owner_id=32'h80010001;link.req_instance_id=16'h1234;link.req_epoch=32'h80000003;
    link.req_task_id=32'h80000004;link.req_request_seq=64'h8000000000000005;
    link.req_context_id=16'd17;link.req_generation=32'h80000006;
    link.req_invocation_id=64'hf000000000000007;link.req_lease_token=64'h8000000000000008;
    link.req_action=0;link.req_template=1;link.req_key_source=1;link.req_key_length=0;
    link.req_message_parts='0;link.req_message_parts[7:0]=2;
    link.req_message_parts[8+:64]=64'hf000000000000009;
    link.public_data_data='1;link.public_data_keep='1;
    if($bits(link.req_invocation_id)!=64||$bits(link.req_request_seq)!=64||
       $bits(link.req_message_parts)!=696||$bits(link.public_data_data)!=DATA_W||
       $bits(link.public_data_keep)!=DATA_W/8)$fatal(1,"MAC call generated width mismatch");
    repeat(3)@(posedge clk);@(negedge clk);reset_n=1;link.req_valid=1;
    repeat(3)begin @(posedge clk);#1;
      if(link.req_invocation_id!==64'hf000000000000007||link.req_context_id!==16'd17||
         link.req_message_parts[8+:64]!==64'hf000000000000009)$fatal(1,"full child/parent/reference namespace lost");
    end
    @(negedge clk);link.req_ready=1;@(posedge clk);#1;
    if(!link.req_valid||!link.req_ready)$fatal(1,"passive view handshake lost");
    $display("TEST_DONE PASS crypto_mac_call_passive_view DATA_W=%0d",DATA_W);$finish;
  end
endmodule
`default_nettype wire
