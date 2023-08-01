package my_sequence_pkg;
	
`include "uvm_macros.svh"


import uvm_pkg::*;

//--------- PACKET ---------------------
class my_transaction extends uvm_sequence_item;

	`uvm_object_utils(my_transaction);


	function new (string name = "");
		super.new(name);
	endfunction


	rand  logic [7:0] code;
	logic pmix_clk;
    logic pmix_clk_90;
	logic pmix_clk_n;
	logic pmix_clk_90_n;



	constraint code_c {code >= 0 ; code <= 255;}


endclass



//--------- SEQUENCE ---------------------
class my_sequence extends uvm_sequence#(my_transaction);

	`uvm_object_utils(my_sequence);


	function new (string name = "");
		super.new(name);
	endfunction

    task body;
	//repeat(256)begin
	for(int i = 0 ; i < 256 ; i ++) begin 
	req = my_transaction::type_id::create("req");
        start_item(req);    // When trigger it go to driver and wait the driver say done in 
                            //order to go to end and send another item

        /*if(!req.randomize()) 
        	`uvm_fatal("My sequence" , "Randomization failed");*/

        	
       req.code = i ;
        	
        

        finish_item(req);
	end

       endtask
endclass

endpackage
