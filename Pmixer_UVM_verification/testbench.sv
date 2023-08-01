`include "uvm_macros.svh"
`include "my_test.sv"

module top;
import uvm_pkg::*;

parameter PERIOD_CLOCK_FAST = 'd4;
parameter PERIOD_CLOCK_SLOW = 'd1018;

//---- INSTANTIATE THE INTERFACE ----
dut_if  dut_if1();

//---- CONNECT THE DUT WITH INTERFACE ----
Pmixer dut (.clk(dut_if1.clk) , .rst_n(dut_if1.rst_n) ,.clk_in(dut_if1.clk_in) ,.code(dut_if1.code) , .pmix_clk(dut_if1.pmix_clk)
	        ,.pmix_clk_90(dut_if1.pmix_clk_90) ,.pmix_clk_n(dut_if1.pmix_clk_n) ,.pmix_clk_90_n(dut_if1.pmix_clk_90_n));



//-------- CLOCK GENERATION -----------

initial begin
	dut_if1.clk = 0;
	forever #(PERIOD_CLOCK_FAST/2) dut_if1.clk = ~ dut_if1.clk;
end


initial begin
	dut_if1.clk_in = 0;
	forever #(PERIOD_CLOCK_SLOW/2) dut_if1.clk_in = ~dut_if1.clk_in;
end

//-------- RESET DESIGN ---------------

initial begin
	dut_if1.rst_n = 0;
	@(posedge dut_if1.clk);
	dut_if1.rst_n = 1; 
end


//-------- START TEST ---------------

initial begin
	run_test("my_test");     // WILL RUN ALL TESTS
end


//------ PUT THE INTERFACE IN THE UVM CONFIGURATION DATABASE --------

initial begin
	uvm_config_db#(virtual dut_if) :: set(null,"*","dut_vif",dut_if1);
	//$dumpfiles("dump.vcd");  // GENERATE WAVEFORM
	//$dumpvars(0,top);        // DISPLAY SIGNALS IN TOP Y#NY KOL AL SIGNALS MN AL 2a5er
end


initial begin
	#(PERIOD_CLOCK_SLOW*1000);
	$stop;
end

endmodule	