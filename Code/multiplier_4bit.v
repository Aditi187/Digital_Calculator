// ============================================================
// 4-bit Unsigned Multiplier for Nexys A7
// 4 x 4 bits → 8-bit product  (max: 15 × 15 = 225 = 0xE1)
// Combinational; synthesized as LUT multiplier by Vivado.
// ============================================================
module multiplier_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] product
);
    assign product = A * B;
endmodule
