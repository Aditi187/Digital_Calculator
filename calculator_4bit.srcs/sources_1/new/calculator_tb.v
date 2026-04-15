// 4-bit Calculator Testbench
// Tests both integer and floating-point modes
`timescale 1ns / 1ps

module calculator_tb;
    // Integer inputs
    reg [3:0] A_int, B_int;
    // Control signals
    reg [2:0] sel;
    // Outputs
    wire [7:0] result;
    wire overflow;

    // Instantiate top module
    top uut (
        .A(A_int),
        .B(B_int),
        .sel(sel),
        .result(result),
        .overflow(overflow)
    );

    initial begin
        // Integer mode tests
        sel = 3'b000; A_int = 4'd5; B_int = 4'd3; #10; // Add
        sel = 3'b001; A_int = 4'd7; B_int = 4'd2; #10; // Sub
        sel = 3'b010; A_int = 4'd3; B_int = 4'd4; #10; // Mul
        sel = 3'b011; A_int = 4'd8; B_int = 4'd2; #10; // Div
        sel = 3'b100; A_int = 4'd9; B_int = 4'd5; #10; // AND
        $display("AND Test: A=%b, B=%b, sel=%b, result=%b, overflow=%b", A_int, B_int, sel, result, overflow);
        sel = 3'b101; A_int = 4'd6; B_int = 4'd3; #10; // OR
        sel = 3'b110; A_int = 4'd7; B_int = 4'd2; #10; // XOR
        
        $finish;
    end
endmodule
