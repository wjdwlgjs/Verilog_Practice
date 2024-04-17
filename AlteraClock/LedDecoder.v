module LedDecoder(
    input [3:0] digit_i,
    input on_i,
    output reg [6:0] seven_seg_o
    );

    always @(*) begin
        if (~on_i) seven_seg_o <= 7'b0000000;
        else begin
            case (digit_i)
                4'b0000 : seven_seg_o <= 7'b1000000;
                4'b0001 : seven_seg_o <= 7'b1111001;
                4'b0010 : seven_seg_o <= 7'b0100100;
                4'b0011 : seven_seg_o <= 7'b0110000;
                4'b0100 : seven_seg_o <= 7'b0011001;
                4'b0101 : seven_seg_o <= 7'b0010010;
                4'b0110 : seven_seg_o <= 7'b0000010;
                4'b0111 : seven_seg_o <= 7'b1111000;
                4'b1000 : seven_seg_o <= 7'b0000000;
                4'b1001 : seven_seg_o <= 7'b0010000;
                default : seven_seg_o <= 7'b0111111;
            endcase
        end
    end
endmodule