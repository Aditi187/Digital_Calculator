`timescale 1ns / 1ps
module alu_integer(
    input [3:0] A,
    input [3:0] B,
    input [2:0] sel,
    output reg [7:0] result,
    output reg overflow
);

reg [4:0] temp_add;
reg [7:0] temp_mul;

    always @(*) begin
        // Reset defaults to avoid latches
        result = 8'b0;
        overflow = 1'b0;
        temp_add = 5'b0;
        temp_mul = 8'b0;

        case(sel)
            3'b000: begin  // Addition
                temp_add = {1'b0, A} + {1'b0, B};
                result = {3'b000, temp_add};
                overflow = (temp_add > 5'd15);
            end
            3'b001: begin  // Subtraction
                if (A < B) begin
                    result = 8'b0;
                    overflow = 1'b1; // Underflow
                end else begin
                    result = {4'b0000, A - B};
                    overflow = 1'b0;
                end
            end
            3'b010: begin  // Multiplication
                temp_mul = A * B;
                result = temp_mul;
                overflow = (temp_mul > 8'd15);
            end
            3'b011: begin  // Division
                if (B == 0) begin
                    result = 8'b0;
                    overflow = 1'b1; // Division by zero
                end else begin
                    result[3:0] = A / B; // Quotient
                    result[7:4] = A % B; // Remainder
                    overflow = 1'b0;
                end
            end
            3'b100: begin  // Bitwise AND
                result = {4'b0000, A & B};
                overflow = 1'b0;
            end
            3'b101: begin  // Bitwise OR
                result = {4'b0000, A | B};
                overflow = 1'b0;
            end
            3'b110: begin  // Bitwise XOR
                result = {4'b0000, A ^ B};
                overflow = 1'b0;
            end
            3'b111: begin  // Bitwise NOT (A)
                result = {4'b0000, ~A};
                overflow = 1'b0;
            end
            default: begin
                result = 8'b0;
                overflow = 1'b0;
            end
        endcase
    end
endmodule