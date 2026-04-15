`timescale 1ns / 1ps
module top(
    input [3:0] A,
    input [3:0] B,
    input [2:0] sel,
    output [7:0] result,
    output overflow
);

wire [7:0] int_result;
wire ov_int;

// Integer ALU only
alu_integer int1(
    .A(A),
    .B(B),
    .sel(sel),
    .result(int_result),
    .overflow(ov_int)
);

assign result = int_result;
assign overflow = ov_int;

endmodule