module seven_seg(
    input wire [3:0] num,
    output reg [6:0] seg
    );

    always @(*) begin
        case(num)
            4'd0 : seg = 7'b1000000;
            4'd1 : seg = 7'b1111001;
            4'd2 : seg = 7'b0100100;
            4'd3 : seg = 7'b0110000;
            4'd4 : seg = 7'b0011001;
            4'd5 : seg = 7'b0010010;
            4'd6 : seg = 7'b0000010;
            4'd7 : seg = 7'b1111000;
            4'd8 : seg = 7'b0000000;
            4'd9 : seg = 7'b0010000;
            default: seg = 7'b0111111;
        endcase
    end
endmodule

module digitdiplmux(
    input clk,
    input rstn,
    input [31:0] clock_values,
    input [31:0] stopwatch_values,
    input [31:0] timer_values,
    input [1:0] sel,

    output reg [55:0] segment_out
    );

    reg [31:0] selected_values;
    wire [6:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
    reg [3:0] num0, num1, num2, num3, num4, num5, num6, num7;

    always @(*) begin
        num0 = selected_values[3:0];
        num1 = selected_values[7:4];
        num2 = selected_values[11:8];
        num3 = selected_values[15:12];
        num4 = selected_values[19:16];
        num5 = selected_values[23:20];
        num6 = selected_values[27:24];
        num7 = selected_values[31:28];
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            selected_values <= 32'b0;
        end
        else begin
            case(sel)
                2'b00: selected_values <= clock_values;
                2'b01: selected_values <= stopwatch_values;
                2'b10: selected_values <= timer_values;
                default: selected_values <= clock_values;
            endcase
        end
    end

    always @(*) begin
        segment_out = {seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7};
    end

    seven_seg s_seg0(.num(num0), .seg(seg0));
    seven_seg s_seg1(.num(num1), .seg(seg1));
    seven_seg s_seg2(.num(num2), .seg(seg2));
    seven_seg s_seg3(.num(num3), .seg(seg3));
    seven_seg s_seg4(.num(num4), .seg(seg4));
    seven_seg s_seg5(.num(num5), .seg(seg5));
    seven_seg s_seg6(.num(num6), .seg(seg6));
    seven_seg s_seg7(.num(num7), .seg(seg7));

endmodule