module Pmixer(
input clk,rst_n,
input clk_in,
input [7:0] code,

output reg  pmix_clk,pmix_clk_90,
output pmix_clk_n,pmix_clk_90_n
);

reg [255:1] clk_;

assign pmix_clk_n = ~ pmix_clk;
assign pmix_clk_90_n = ~ pmix_clk_90;


genvar i;
generate
  for (i = 1; i <= 255; i = i + 1) begin : always_block
    always @(posedge clk or negedge rst_n) begin
      
      if (~rst_n) begin
        clk_[i] <= 0;
      end 

      else if(i == 1) clk_[1] <= clk_in;

      else begin
        clk_[i] <= clk_[i-1]; 
        end
    end
  end
endgenerate


always @(posedge clk or negedge rst_n)
begin

if(!rst_n) begin
 pmix_clk <= 0;
 pmix_clk_90 <= 0;
end

else begin
   if(code == 0) begin
    pmix_clk <= clk_in;
    pmix_clk_90 <= clk_[1];
   end

   else if(code == 255) begin
    pmix_clk    <= clk_[code];
    pmix_clk_90 <= clk_in;
    end

   else begin
   pmix_clk    <= clk_[code];
   pmix_clk_90 <= clk_[code+1];
   end

end
end

endmodule
