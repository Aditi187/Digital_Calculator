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
            // Double Dabble Algorithm
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
