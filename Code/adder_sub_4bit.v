// 4-bit Adder/Subtractor – unchanged, fully portable Verilog
module adder_sub_4bit(
    input  [3:0] A, B,
    input        s,         // 0 = add, 1 = subtract
    output [3:0] SUM,
    output       cout
);
    wire [3:0] B_in = B ^ {4{s}};  // invert B when subtracting (2's complement)
    wire c1, c2, c3;

    full_adder FA0 (A[0], B_in[0], s,  SUM[0], c1);
    full_adder FA1 (A[1], B_in[1], c1, SUM[1], c2);
    full_adder FA2 (A[2], B_in[2], c2, SUM[2], c3);
    full_adder FA3 (A[3], B_in[3], c3, SUM[3], cout);
endmodule