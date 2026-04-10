module alu(
    input [3:0] A,
    input [3:0] B,
    input [2:0] sel,
    output reg [7:0] result,
    output reg overflow
);

always @(*) 
begin
    overflow = 0;

    case(sel)

        3'b000:
        begin
            result = A + B;
            if(result > 15) overflow = 1;
        end

        3'b001:
        begin
            result = A - B;
        end

        3'b010:
        begin
            result = A & B;
        end

        3'b011:
        begin
            result = A | B;
        end

        3'b100:
        begin
            result = A ^ B;
        end

        3'b101:
        begin
            result = A * B;
            if(result > 15) overflow = 1;
        end

        3'b110:
        begin
            result = A << 1;
        end

        3'b111:
        begin
            result = A >> 1;
        end

    endcase

end

endmodule