module control(

input clk,
input [2:0] sel_in,
output reg [2:0] sel_out

);

always @(posedge clk)
begin
sel_out <= sel_in;
end

endmodule