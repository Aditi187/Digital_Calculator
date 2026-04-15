// ============================================================
// 4-bit Unsigned Divider for Nexys A7
// A ÷ B → 4-bit quotient + 4-bit remainder
//
// Divide-by-zero protection:
//   When B = 0, div_by_zero = 1 and both outputs are forced
//   to 4'hF so the top module can display "Err".
//
// Note: Verilog '/' and '%' on constant-width signals are
//       fully synthesizable on Xilinx Artix-7.
// ============================================================
module divider_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output [3:0] quotient,
    output [3:0] remainder,
    output       div_by_zero
);
    assign div_by_zero = (B == 4'b0000);
    assign quotient    = div_by_zero ? 4'hF : (A / B);
    assign remainder   = div_by_zero ? 4'hF : (A % B);
endmodule
