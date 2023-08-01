`include "uvm_macros.svh"

import my_sequence_pkg::*;

import uvm_pkg ::*;


class my_scoreboard extends  uvm_scoreboard;

`uvm_component_utils(my_scoreboard);

virtual dut_if dut_vif;
logic [7:0] code_prev;

uvm_analysis_imp#(my_transaction,my_scoreboard) item_collected_export;

my_transaction data_to_check;


function new(string name , uvm_component parent);
  	super.new(name , parent);
  	data_to_check = new();
  	item_collected_export = new("item_collected_export",this);
endfunction


virtual function void write(my_transaction pkt);
   data_to_check = pkt; 
endfunction



function void build_phase (uvm_phase phase);
  super.build_phase(phase);
   	if(!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif",dut_vif )) begin  // ht2oly ana leh m7tago h2olk 34an al clock
   		 `uvm_fatal("","uvm config get failed");
   		end

   	uvm_config_db #(logic [7:0])::set(this, "/signals/code_prev", code_prev);
	
endfunction


task run_phase(uvm_phase phase);


@(posedge dut_vif.clk);
code_prev = data_to_check.code;


forever begin
	@(posedge dut_vif.clk);

	if(code_prev != data_to_check.code) begin

   repeat(data_to_check.code - 1) @(posedge dut_vif.clk); 
      if(data_to_check.pmix_clk == 0) begin
      	 @(posedge dut_vif.clk) if(data_to_check.pmix_clk) `uvm_info("CHECKER" , "PHASE SHIFT IS CORRECT",UVM_MEDIUM);
      end

      else begin
      	`uvm_error("CHECKER","PHASE SHIFT IS WRONG");
      end
  end

    code_prev = data_to_check.code;

end 

endtask

endclass
