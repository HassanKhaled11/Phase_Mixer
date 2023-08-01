`include "uvm_macros.svh"
`include "Pmixer.sv"
//`include "my_sequence.sv"
import my_sequence_pkg::*;

import uvm_pkg::*;

class my_monitor extends uvm_monitor;

	`uvm_component_utils(my_monitor);


    virtual dut_if  dut_vif;  // don't forget virtual keyword as this is a pointer


    my_transaction data_collected;
    uvm_analysis_port #(my_transaction) item_collected_port;
   



	function new(string name , uvm_component parent);
		super.new(name,parent);
		item_collected_port = new("item_collected_port",this);
		data_collected = new();
	endfunction



   function void build_phase (uvm_phase phase);
   	super.build_phase(phase);
   	if(!uvm_config_db#(virtual dut_if)::get(this, "", "dut_vif",dut_vif )) begin
   		 `uvm_fatal("","uvm config get failed");
   		end
   endfunction


  task run_phase(uvm_phase phase);
    forever begin
      @(posedge dut_vif.clk)

      	data_collected.pmix_clk = dut_vif.pmix_clk;
      	data_collected.pmix_clk_90 = dut_vif.pmix_clk_90;
      	data_collected.pmix_clk_n = dut_vif.pmix_clk_n;
        data_collected.pmix_clk_90_n = dut_vif.pmix_clk_90_n;
 
      	item_collected_port.write(data_collected);
    end
  endtask : run_phase

endclass



