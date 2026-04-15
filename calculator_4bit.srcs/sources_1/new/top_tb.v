`timescale 1ns / 1ps

module top_tb;

reg [3:0] A, B;
reg [2:0] sel;
wire [7:0] result;
wire overflow;

// Instantiate top module
top uut (
    .A(A),
    .B(B),
    .sel(sel),
    .result(result),
    .overflow(overflow)
);

initial begin
    $display("===== Testing Integer ALU =====");
    
    // Test Addition
    $display("\n--- Addition Tests ---");
    A = 4'd5; B = 4'd3; sel = 3'b000; #10;
    $display("A=%d, B=%d, sel=000 (ADD): result=%d, overflow=%b (Expected: 8)", A, B, result, overflow);
    
    A = 4'd15; B = 4'd1; sel = 3'b000; #10;
    $display("A=%d, B=%d, sel=000 (ADD): result=%d, overflow=%b (Expected: 16 with overflow)", A, B, result, overflow);
    
    A = 4'd8; B = 4'd7; sel = 3'b000; #10;
    $display("A=%d, B=%d, sel=000 (ADD): result=%d, overflow=%b (Expected: 15)", A, B, result, overflow);
    
    // Test Subtraction
    $display("\n--- Subtraction Tests ---");
    A = 4'd10; B = 4'd3; sel = 3'b001; #10;
    $display("A=%d, B=%d, sel=001 (SUB): result=%d, overflow=%b (Expected: 7)", A, B, result, overflow);
    
    A = 4'd3; B = 4'd10; sel = 3'b001; #10;
    $display("A=%d, B=%d, sel=001 (SUB): result=%d, overflow=%b (Expected: 0 with overflow)", A, B, result, overflow);
    
    A = 4'd15; B = 4'd5; sel = 3'b001; #10;
    $display("A=%d, B=%d, sel=001 (SUB): result=%d, overflow=%b (Expected: 10)", A, B, result, overflow);
    
    // Test Multiplication
    $display("\n--- Multiplication Tests ---");
    A = 4'd3; B = 4'd4; sel = 3'b010; #10;
    $display("A=%d, B=%d, sel=010 (MUL): result=%d, overflow=%b (Expected: 12, overflow=0)", A, B, result, overflow);
    
    A = 4'd15; B = 4'd2; sel = 3'b010; #10;
    $display("A=%d, B=%d, sel=010 (MUL): result=%d, overflow=%b (Expected: 30, overflow=1)", A, B, result, overflow);
    
    // Test Division
    $display("\n--- Division Tests ---");
    A = 4'd12; B = 4'd3; sel = 3'b011; #10;
    $display("A=%d, B=%d, sel=011 (DIV): Quotient=%d, Remainder=%d, overflow=%b (Expected: Q=4, R=0)", A, B, result[3:0], result[7:4], overflow);
    
    A = 4'd15; B = 4'd4; sel = 3'b011; #10;
    $display("A=%d, B=%d, sel=011 (DIV): Quotient=%d, Remainder=%d, overflow=%b (Expected: Q=3, R=3)", A, B, result[3:0], result[7:4], overflow);
    
    A = 4'd10; B = 4'd0; sel = 3'b011; #10;
    $display("A=%d, B=%d, sel=011 (DIV): Result=%d, overflow=%b (Expected: DivByZero, overflow=1)", A, B, result, overflow);

    // Test Logical Operations
    $display("\n--- Logical Tests ---");
    A = 4'b1010; B = 4'b1100; sel = 3'b100; #10; // AND
    $display("A=%b, B=%b, sel=100 (AND): result=%b (Expected: 1000)", A, B, result[3:0]);
    
    A = 4'b1010; B = 4'b1100; sel = 3'b101; #10; // OR
    $display("A=%b, B=%b, sel=101 (OR):  result=%b (Expected: 1110)", A, B, result[3:0]);
    
    A = 4'b1010; B = 4'b1100; sel = 3'b110; #10; // XOR
    $display("A=%b, B=%b, sel=110 (XOR): result=%b (Expected: 0110)", A, B, result[3:0]);
    
    A = 4'b1010; sel = 3'b111; #10; // NOT
    $display("A=%b, sel=111 (NOT A): result=%b (Expected: 0101)", A, result[3:0]);
    
    $display("\n===== All Tests Complete =====");
    $finish;
end

endmodule
