// Seven-Segment Decoder – Nexys A7 (Active-HIGH cathodes)
// ----------------------------------------------------------
// IMPORTANT CHANGE FROM DE10-Lite VERSION:
//   DE10-Lite HEX displays are ACTIVE-LOW  → segments OFF when bit = 1
//   Nexys A7  SEG  display  is ACTIVE-HIGH → segments ON  when bit = 1
//
// Therefore the final ~seg_raw inversion is REMOVED for Nexys A7.
// The Nexys A7 anodes (AN) are active-low and are driven by the
// top-level multiplexer, NOT by this module.
// ----------------------------------------------------------

module sevenseg_decoder (
    input  [3:0] hex,   // 4-bit value to display (0–F)
    output [6:0] seg    // Segment bits {g,f,e,d,c,b,a} — ACTIVE-HIGH
);

    // Individual segment logic (active-HIGH: 1 = segment ON)
    wire [6:0] seg_raw;

    // seg_raw[0] – segment a (top)
    // ON for: 0,2,3,5,6,7,8,9,A,C,E,F
    assign seg_raw[0] = (~hex[3]&~hex[2]&~hex[1]&~hex[0]) |  // 0
                        (~hex[3]&~hex[2]& hex[1]&~hex[0]) |  // 2
                        (~hex[3]&~hex[2]& hex[1]& hex[0]) |  // 3
                        (~hex[3]& hex[2]&~hex[1]& hex[0]) |  // 5
                        (~hex[3]& hex[2]& hex[1]&~hex[0]) |  // 6
                        (~hex[3]& hex[2]& hex[1]& hex[0]) |  // 7
                        ( hex[3]&~hex[2]&~hex[1]&~hex[0]) |  // 8
                        ( hex[3]&~hex[2]&~hex[1]& hex[0]) |  // 9
                        ( hex[3]&~hex[2]& hex[1]&~hex[0]) |  // A
                        ( hex[3]& hex[2]&~hex[1]&~hex[0]) |  // C
                        ( hex[3]& hex[2]& hex[1]&~hex[0]) |  // E
                        ( hex[3]& hex[2]& hex[1]& hex[0]);   // F

    // seg_raw[1] – segment b (top-right)
    // ON for: 0,1,2,3,4,7,8,9,A,D
    assign seg_raw[1] = (~hex[3]&~hex[2]&~hex[1]&~hex[0]) | (~hex[3]&~hex[2]&~hex[1]& hex[0]) |
                        (~hex[3]&~hex[2]& hex[1]&~hex[0]) | (~hex[3]&~hex[2]& hex[1]& hex[0]) |
                        (~hex[3]& hex[2]&~hex[1]&~hex[0]) | (~hex[3]& hex[2]& hex[1]& hex[0]) |
                        ( hex[3]&~hex[2]&~hex[1]&~hex[0]) | ( hex[3]&~hex[2]&~hex[1]& hex[0]) |
                        ( hex[3]&~hex[2]& hex[1]&~hex[0]) | ( hex[3]& hex[2]&~hex[1]& hex[0]);

    // seg_raw[2] – segment c (bottom-right)
    // ON for: 0,1,3,4,5,6,7,8,9,A,B,D
    assign seg_raw[2] = (~hex[3]&~hex[2]&~hex[1]&~hex[0]) |  // 0
                        (~hex[3]&~hex[2]&~hex[1]& hex[0]) |  // 1
                        (~hex[3]&~hex[2]& hex[1]& hex[0]) |  // 3
                        (~hex[3]& hex[2]&~hex[1]&~hex[0]) |  // 4
                        (~hex[3]& hex[2]&~hex[1]& hex[0]) |  // 5
                        (~hex[3]& hex[2]& hex[1]&~hex[0]) |  // 6
                        (~hex[3]& hex[2]& hex[1]& hex[0]) |  // 7
                        ( hex[3]&~hex[2]&~hex[1]&~hex[0]) |  // 8
                        ( hex[3]&~hex[2]&~hex[1]& hex[0]) |  // 9
                        ( hex[3]&~hex[2]& hex[1]&~hex[0]) |  // A
                        ( hex[3]&~hex[2]& hex[1]& hex[0]) |  // B
                        ( hex[3]& hex[2]&~hex[1]& hex[0]);   // D

    // seg_raw[3] – segment d (bottom)
    // ON for: 0,2,3,5,6,8,9,B,C,D,E
    assign seg_raw[3] = (~hex[3]&~hex[2]&~hex[1]&~hex[0]) | (~hex[3]&~hex[2]& hex[1]&~hex[0]) |
                        (~hex[3]&~hex[2]& hex[1]& hex[0]) | (~hex[3]& hex[2]&~hex[1]& hex[0]) |
                        (~hex[3]& hex[2]& hex[1]&~hex[0]) | ( hex[3]&~hex[2]&~hex[1]&~hex[0]) |
                        ( hex[3]&~hex[2]&~hex[1]& hex[0]) | ( hex[3]&~hex[2]& hex[1]& hex[0]) |
                        ( hex[3]& hex[2]&~hex[1]&~hex[0]) | ( hex[3]& hex[2]&~hex[1]& hex[0]) |
                        ( hex[3]& hex[2]& hex[1]&~hex[0]);

    // seg_raw[4] – segment e (bottom-left)
    // ON for: 0,2,6,8,A,B,C,D,E,F
    assign seg_raw[4] = (~hex[3]&~hex[2]&~hex[1]&~hex[0]) | (~hex[3]&~hex[2]& hex[1]&~hex[0]) |
                        (~hex[3]& hex[2]& hex[1]&~hex[0])  | ( hex[3]&~hex[2]&~hex[1]&~hex[0]) |
                        ( hex[3]&~hex[2]& hex[1]&~hex[0])  | ( hex[3]&~hex[2]& hex[1]& hex[0]) |
                        ( hex[3]& hex[2]&~hex[1]&~hex[0])  | ( hex[3]& hex[2]&~hex[1]& hex[0]) |
                        ( hex[3]& hex[2]& hex[1]&~hex[0])  | ( hex[3]& hex[2]& hex[1]& hex[0]);

    // seg_raw[5] – segment f (top-left)
    // ON for: 0,4,5,6,8,9,A,B,C,E,F
    assign seg_raw[5] = (~hex[3]&~hex[2]&~hex[1]&~hex[0]) | (~hex[3]& hex[2]&~hex[1]&~hex[0]) |
                        (~hex[3]& hex[2]&~hex[1]& hex[0])  | (~hex[3]& hex[2]& hex[1]&~hex[0]) |
                        ( hex[3]&~hex[2]&~hex[1]&~hex[0])  | ( hex[3]&~hex[2]&~hex[1]& hex[0]) |
                        ( hex[3]&~hex[2]& hex[1]&~hex[0])  | ( hex[3]&~hex[2]& hex[1]& hex[0]) |
                        ( hex[3]& hex[2]&~hex[1]&~hex[0])  | ( hex[3]& hex[2]& hex[1]&~hex[0]) |
                        ( hex[3]& hex[2]& hex[1]& hex[0]);

    // seg_raw[6] – segment g (middle)
    // ON for: 2,3,4,5,6,8,9,A,B,D,E,F
    assign seg_raw[6] = (~hex[3]&~hex[2]& hex[1]&~hex[0]) |  // 2
                        (~hex[3]&~hex[2]& hex[1]& hex[0]) |  // 3
                        (~hex[3]& hex[2]&~hex[1]&~hex[0]) |  // 4
                        (~hex[3]& hex[2]&~hex[1]& hex[0]) |  // 5
                        (~hex[3]& hex[2]& hex[1]&~hex[0]) |  // 6
                        ( hex[3]&~hex[2]&~hex[1]&~hex[0]) |  // 8
                        ( hex[3]&~hex[2]&~hex[1]& hex[0]) |  // 9
                        ( hex[3]&~hex[2]& hex[1]&~hex[0]) |  // A
                        ( hex[3]&~hex[2]& hex[1]& hex[0]) |  // B
                        ( hex[3]& hex[2]&~hex[1]& hex[0]) |  // D
                        ( hex[3]& hex[2]& hex[1]&~hex[0]) |  // E
                        ( hex[3]& hex[2]& hex[1]& hex[0]);   // F

    // NEXYS A7: segments are ACTIVE-LOW (0 = ON, 1 = OFF)
    // We bitwise invert seg_raw to achieve this.
    assign seg = ~seg_raw;

endmodule