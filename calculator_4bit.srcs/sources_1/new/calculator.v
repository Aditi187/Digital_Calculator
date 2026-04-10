module calculator(
    input [3:0] A,
    input [3:0] B,
    input [1:0] sel,
    output reg [4:0] result
);

always @(*) 
begin
    case(sel)
        2'b00: result = A + B;   // Addition
        2'b01: result = A - B;   // Subtraction
        2'b10: result = A & B;   // AND
        2'b11: result = A | B;   // OR
    endcase
end

endmodule