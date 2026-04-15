// ============================================================
// FPGA 4-bit Arithmetic Calculator – Top Module for Nexys A7
// Ported from Intel DE10-Lite (Quartus) to Nexys A7 (Vivado)
//
// Operations (SW[9:8]):
//   2'b00 – Addition        (A + B)
//   2'b01 – Subtraction     (A – B, two's complement)
//   2'b10 – Multiplication  (A × B, 8-bit result)
//   2'b11 – Division        (A ÷ B, quotient + remainder)
//
// Inputs:
//   SW[3:0]  = Operand A
//   SW[7:4]  = Operand B
//   SW[9:8]  = Mode select (see above)
//
// Display layout (AN[7]=leftmost … AN[0]=rightmost):
//
//  Mode  | [7]  [6]  [5]  [4]  [3]  [2]  [1]   [0]
//  ADD   |  A   [ ]   B   [ ]  [ ]  [ ]  [CY]  [SUM]
//  SUB   |  A   [ ]   B   [ ]  [ ]  [ ]  [- ]  [MAG]
//  MUL   |  A   [ ]   B   [ ]  [ ]  [ ]  [P1]  [P0]
//  DIV   |  A   [ ]   B   [ ]  [Q]  [ ]  [r ]  [REM]
//  Err   |  A   [ ]   B   [ ]  [E]  [E]  [E ]  [E ]  (÷0)
//
//  CY  = carry ("1" or blank)
//  -   = minus sign or blank
//  P1  = upper nibble of product (hex)
//  P0  = lower nibble of product (hex)
//  Q   = quotient (hex)
//  r   = literal lowercase 'r' character
//  REM = remainder (hex)
//  E   = error character (÷ by zero)
// ============================================================

module lab3_top (
    input        clk,       // 100 MHz system clock (Nexys A7 pin E3)
    input  [9:0] SW,        // SW[3:0]=A, SW[7:4]=B, SW[9:8]=mode
    output [6:0] SEG,       // Shared cathode segments {g,f,e,d,c,b,a} — ACTIVE-HIGH
    output       DP,        // Decimal point (active-low, tie 1 = OFF)
    output [7:0] AN         // Digit anodes, active-low (AN[7]=leftmost)
);

    // ----------------------------------------------------------------
    // Inputs
    // ----------------------------------------------------------------
    wire [3:0] A    = SW[3:0];
    wire [3:0] B    = SW[7:4];
    wire [1:0] mode = SW[9:8];  // 00=add  01=sub  10=mul  11=div

    // ----------------------------------------------------------------
    // Addition / Subtraction
    // ----------------------------------------------------------------
    wire        s_addsub = mode[0];   // 0=add, 1=sub (valid when mode[1]=0)
    wire [3:0]  SUM;
    wire        cout;
    adder_sub_4bit U_ADD (A, B, s_addsub, SUM, cout);

    // Magnitude (undo 2's complement when result is negative)
    wire        negative = (mode == 2'b01) && !cout;
    wire [3:0]  mag      = negative ? (~SUM + 4'd1) : SUM;

    // ----------------------------------------------------------------
    // Multiplication  (4×4 → 8-bit result)
    // ----------------------------------------------------------------
    wire [7:0] product;
    multiplier_4bit U_MUL (A, B, product);

    // ----------------------------------------------------------------
    // Division  (4÷4 → 4-bit quotient + 4-bit remainder)
    // ----------------------------------------------------------------
    wire [3:0]  quotient, remainder;
    wire        div_by_zero;
    divider_4bit U_DIV (A, B, quotient, remainder, div_by_zero);

    // ----------------------------------------------------------------
    // BCD Converters for Decimal Display
    // ----------------------------------------------------------------
    wire [3:0] a_tens, a_units, a_h;
    wire [3:0] b_tens, b_units, b_h;
    wire [3:0] res_h, res_t, res_u;
    wire [3:0] q_tens, q_u, q_h;

    bin_to_bcd BCD_A ({{4{1'b0}}, A}, a_h, a_tens, a_units);
    bin_to_bcd BCD_B ({{4{1'b0}}, B}, b_h, b_tens, b_units);
    
    // Multi-purpose result converter
    wire [7:0] val_to_convert = (mode == 2'b10) ? product : {4'b0000, mag};
    bin_to_bcd BCD_RES (val_to_convert, res_h, res_t, res_u);
    
    // Division quotient converter
    bin_to_bcd BCD_Q ({{4{1'b0}}, quotient}, q_h, q_tens, q_u);

    // ----------------------------------------------------------------
    // 7-segment decoders for BCD digits
    // ----------------------------------------------------------------
    wire [6:0] segA_t, segA_u, segB_t, segB_u;
    wire [6:0] segRh, segRt, segRu;
    wire [6:0] segQt, segQu, segREM;
    
    sevenseg_decoder H_At (a_tens, segA_t);
    sevenseg_decoder H_Au (a_units, segA_u);
    sevenseg_decoder H_Bt (b_tens, segB_t);
    sevenseg_decoder H_Bu (b_units, segB_u);
    
    sevenseg_decoder H_Rh (res_h, segRh);
    sevenseg_decoder H_Rt (res_t, segRt);
    sevenseg_decoder H_Ru (res_u, segRu);
    
    sevenseg_decoder H_Qt (q_tens, segQt);
    sevenseg_decoder H_Qu (q_u, segQu);
    sevenseg_decoder H_RM (remainder, segREM);

    // ----------------------------------------------------------------
    // Constant 7-segment patterns (ACTIVE-LOW for Nexys A7)
    // ----------------------------------------------------------------
    // Mapping: {g, f, e, d, c, b, a} — ACTIVE-LOW (0 = ON, 1 = OFF)
    localparam [6:0] SEG_ONE   = 7'b111_1001; // segments b,c = 0
    localparam [6:0] SEG_MINUS = 7'b011_1111; // segment g = 0
    localparam [6:0] SEG_r     = 7'b010_1111; // segments e,g = 0
    localparam [6:0] SEG_E     = 7'b000_0110; // segments a,d,e,f,g = 0
    localparam [6:0] SEG_BLANK = 7'b111_1111; // all segments off = 1
    // ----------------------------------------------------------------
    // Digit mux — assign each of the 8 digit slots based on mode
    // ----------------------------------------------------------------
    reg [6:0] digit [7:0];

    always @(*) begin
        // Operand display positions (AN7-AN4)
        digit[7] = (a_tens == 0) ? SEG_BLANK : segA_t; // Leading zero suppression
        digit[6] = segA_u;
        digit[5] = (b_tens == 0) ? SEG_BLANK : segB_t;
        digit[4] = segB_u;

        case (mode)
            // ----------------------------------------------------------
            2'b00: begin  // ADDITION
                digit[3] = SEG_BLANK;
                digit[2] = (res_h == 0) ? SEG_BLANK : segRh;
                digit[1] = (res_h == 0 && res_t == 0) ? SEG_BLANK : segRt;
                digit[0] = segRu;
            end

            // ----------------------------------------------------------
            2'b01: begin  // SUBTRACTION
                digit[3] = (negative) ? SEG_MINUS : SEG_BLANK;
                digit[2] = SEG_BLANK;
                digit[1] = (res_t == 0) ? SEG_BLANK : segRt;
                digit[0] = segRu;
            end

            // ----------------------------------------------------------
            2'b10: begin  // MULTIPLICATION (3 digits max: 225)
                digit[3] = SEG_BLANK;
                digit[2] = (res_h == 0) ? SEG_BLANK : segRh;
                digit[1] = (res_h == 0 && res_t == 0) ? SEG_BLANK : segRt;
                digit[0] = segRu;
            end

            // ----------------------------------------------------------
            2'b11: begin  // DIVISION
                if (div_by_zero) begin
                    digit[3] = SEG_E;
                    digit[2] = SEG_E;
                    digit[1] = SEG_E;
                    digit[0] = SEG_E;
                end else begin
                    digit[3] = (q_tens == 0) ? SEG_BLANK : segQt;
                    digit[2] = segQu;
                    digit[1] = SEG_r;
                    digit[0] = segREM; // Remainder is 4-bit, max 14 (if div by 15). Wait, if B=15, Rem can be 14. 
                                       // Hex to dec for remainder? Let's just use hex or BCD? 
                                       // For simplicity, let's keep remainder as 1 digit hex unless it's > 9.
                                       // Actually, let's just use the decoded segREM (hex/dec is same for 0-9).
                end
            end

            default: begin
                digit[3] = SEG_BLANK;
                digit[2] = SEG_BLANK;
                digit[1] = SEG_BLANK;
                digit[0] = SEG_BLANK;
            end
        endcase
    end

    // ----------------------------------------------------------------
    // Multiplexed refresh counter
    // 100 MHz / 2^17 ≈ 763 Hz total → ~95 Hz per digit (flicker-free)
    // ----------------------------------------------------------------
    reg [16:0] refresh_cnt;
    always @(posedge clk)
        refresh_cnt <= refresh_cnt + 1'b1;

    wire [2:0] digit_sel = refresh_cnt[16:14];  // cycles 0–7

    // ----------------------------------------------------------------
    // Drive SEG and AN outputs
    // ----------------------------------------------------------------
    reg [6:0] seg_reg;
    reg [7:0] an_reg;

    always @(*) begin
        an_reg  = 8'b1111_1111;   // all anodes off by default (active-low)
        seg_reg = SEG_BLANK;

        case (digit_sel)
            3'd0: begin an_reg[0] = 1'b0; seg_reg = digit[0]; end
            3'd1: begin an_reg[1] = 1'b0; seg_reg = digit[1]; end
            3'd2: begin an_reg[2] = 1'b0; seg_reg = digit[2]; end
            3'd3: begin an_reg[3] = 1'b0; seg_reg = digit[3]; end
            3'd4: begin an_reg[4] = 1'b0; seg_reg = digit[4]; end
            3'd5: begin an_reg[5] = 1'b0; seg_reg = digit[5]; end
            3'd6: begin an_reg[6] = 1'b0; seg_reg = digit[6]; end
            3'd7: begin an_reg[7] = 1'b0; seg_reg = digit[7]; end
        endcase
    end

    assign SEG = seg_reg;
    assign AN  = an_reg;
    assign DP  = 1'b1;  // decimal point OFF (active-low → 1 = off)

endmodule

// ============================================================
// Helper Module: Binary to BCD Converter (Double Dabble)
// ============================================================
module bin_to_bcd (
    input      [7:0] bin,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] units
);
    integer i;
    reg [11:0] bcd;
    always @(*) begin
        bcd = 12'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;
            if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
            if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
            bcd = {bcd[10:0], bin[7-i]};
        end
        hundreds = bcd[11:8];
        tens     = bcd[7:4];
        units    = bcd[3:0];
    end
endmodule
