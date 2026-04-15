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
    input        clk,       // 100 MHz system clock (Nexys A7 pin W5)
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
    // 7-segment decoders
    // ----------------------------------------------------------------
    wire [6:0] segA, segB, segR, segP0, segP1, segQ, segREM;
    sevenseg_decoder H_A   (A,              segA);
    sevenseg_decoder H_B   (B,              segB);
    sevenseg_decoder H_R   (mag,            segR);    // add/sub result
    sevenseg_decoder H_P1  (product[7:4],   segP1);  // upper nibble of product
    sevenseg_decoder H_P0  (product[3:0],   segP0);  // lower nibble of product
    sevenseg_decoder H_Q   (quotient,       segQ);   // quotient
    sevenseg_decoder H_REM (remainder,      segREM); // remainder

    // ----------------------------------------------------------------
    // Constant 7-segment patterns (ACTIVE-HIGH for Nexys A7)
    //
    //  Segment bit mapping: {g, f, e, d, c, b, a}
    //   SEG_ONE   = "1"  → segments b,c         = 7'b000_0110
    //   SEG_MINUS = "–"  → segment g only        = 7'b100_0000
    //   SEG_r     = "r"  → segments e,g          = 7'b101_0000
    //   SEG_E     = "E"  → segments a,d,e,f,g    = 7'b111_1001
    //   SEG_BLANK = all segments off             = 7'b000_0000
    // ----------------------------------------------------------------
    localparam [6:0] SEG_ONE   = 7'b000_0110;
    localparam [6:0] SEG_MINUS = 7'b100_0000;
    localparam [6:0] SEG_r     = 7'b101_0000;
    localparam [6:0] SEG_E     = 7'b111_1001;
    localparam [6:0] SEG_BLANK = 7'b000_0000;

    // ----------------------------------------------------------------
    // Digit mux — assign each of the 8 digit slots based on mode
    // ----------------------------------------------------------------
    reg [6:0] digit [7:0];

    always @(*) begin
        // Operand display positions — same for all modes
        digit[7] = segA;       // Operand A (leftmost)
        digit[6] = SEG_BLANK;  // spacer
        digit[5] = segB;       // Operand B
        digit[4] = SEG_BLANK;  // spacer

        case (mode)
            // ----------------------------------------------------------
            2'b00: begin  // ADDITION
                digit[3] = SEG_BLANK;
                digit[2] = SEG_BLANK;
                digit[1] = cout ? SEG_ONE : SEG_BLANK;  // carry "1" or blank
                digit[0] = segR;                         // 4-bit sum
            end

            // ----------------------------------------------------------
            2'b01: begin  // SUBTRACTION
                digit[3] = SEG_BLANK;
                digit[2] = SEG_BLANK;
                digit[1] = negative ? SEG_MINUS : SEG_BLANK;  // "–" if negative
                digit[0] = segR;                               // magnitude
            end

            // ----------------------------------------------------------
            2'b10: begin  // MULTIPLICATION  (8-bit result = 2 hex digits)
                digit[3] = SEG_BLANK;
                digit[2] = SEG_BLANK;
                digit[1] = segP1;  // upper nibble  e.g. 0xE for 225
                digit[0] = segP0;  // lower nibble
            end

            // ----------------------------------------------------------
            2'b11: begin  // DIVISION
                if (div_by_zero) begin
                    // Show "E E E E" across result positions
                    digit[3] = SEG_E;
                    digit[2] = SEG_E;
                    digit[1] = SEG_E;
                    digit[0] = SEG_E;
                end else begin
                    digit[3] = segQ;     // quotient  (e.g. "3" for 15÷5)
                    digit[2] = SEG_BLANK;
                    digit[1] = SEG_r;    // lowercase 'r' (remainder indicator)
                    digit[0] = segREM;   // remainder (e.g. "0" for 15÷5)
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
