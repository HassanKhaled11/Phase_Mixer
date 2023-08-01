module Pmixer_TB;

  // Parameters
  parameter PERIOD_fast_clk = 2; // Time units for clock period
  parameter PERIOD_slow_clk = 514; // Time units for clock period

  // Inputs
  reg clk, rst_n;
  reg clk_in;
  reg [7:0] code;

  // Outputs
  wire pmix_clk, pmix_clk_90;
  wire pmix_clk_n, pmix_clk_90_n;
    
  integer i; 
  // Instantiate the Pmixer module
  Pmixer dut(
    .clk(clk),
    .rst_n(rst_n),
    .clk_in(clk_in),
    .code(code),
    .pmix_clk(pmix_clk),
    .pmix_clk_90(pmix_clk_90),
    .pmix_clk_n(pmix_clk_n),
    .pmix_clk_90_n(pmix_clk_90_n)
  );

  // Clock generation
  always #((PERIOD_fast_clk / 2)) clk = ~clk;
  always #((PERIOD_slow_clk / 2)) clk_in = ~clk_in;

  // Reset generation
  initial begin
    clk = 0 ;
    clk_in = 0;
    rst_n = 0;
    #((PERIOD_slow_clk * 2));
    rst_n = 1;
  end

  // Stimulus
  initial begin
    // Wait for a few clock cycles after reset
    #((PERIOD_fast_clk * 10));


    for (i = 0 ; i <= 255 ; i = i +1 ) begin
    code <= i;
    #((PERIOD_slow_clk * 10));
    end
 

    // End of simulation
    $stop;
  end

endmodule

