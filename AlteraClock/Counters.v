// `include "AlteraClock/FFJK.v"

/* module Counter4Bit(
    input up_i,
    input down_i,
    input clk_i,
    input nreset_i,
    input [3:0] limit_i,

    output [3:0] count_o,
    output carryup_o, // 1 if count == limit and up = 1
    output carrydown_o // 1 if count == 0000 and down = 1
    );

    wire [3:0] toggle;
    wire islim;
    wire iszero;
    
    assign islim = (count_o == limit_i);
    assign iszero = (count_o == 4'b0000);

    assign carryup_o = islim & up_i;
    assign carrydown_o = iszero & down_i & ~up_i;

    assign toggle[0] = 1;
    FFJK FirstBit(
        .j_i(up_i & ~islim & toggle[0] | ~up_i & down_i & ~iszero & toggle[0] | ~up_i & down_i & ~islim & iszero & limit_i[0]),
        .k_i(islim & iszero | up_i & islim | up_i & ~islim & toggle[0] | ~up_i & down_i & ~iszero & toggle[0] | ~up_i & down_i & ~islim & iszero & ~limit_i[0]),
        .nreset_i(nreset_i),
        .enable_i(clk_i),
        .q_o(count_o[0])
    );

    assign toggle[1] = toggle[0] & (count_o[0] & up_i | ~count_o[0] & down_i & ~up_i);
    FFJK SecondBit(
        .j_i(up_i & ~islim & toggle[1] | ~up_i & down_i & ~iszero & toggle[1] | ~up_i & down_i & ~islim & iszero & limit_i[1]),
        .k_i(islim & iszero | up_i & islim | up_i & ~islim & toggle[1] | ~up_i & down_i & ~iszero & toggle[1] | ~up_i & down_i & ~islim & iszero & ~limit_i[1]),
        .nreset_i(nreset_i), 
        .enable_i(clk_i),
        .q_o(count_o[1])
    );

    assign toggle[2] = toggle[1] & (count_o[1] & up_i | ~count_o[1] & down_i & ~up_i);
    FFJK ThirdBit(
        .j_i(up_i & ~islim & toggle[2] | ~up_i & down_i & ~iszero & toggle[2] | ~up_i & down_i & ~islim & iszero & limit_i[2]),
        .k_i(islim & iszero | up_i & islim | up_i & ~islim & toggle[2] | ~up_i & down_i & ~iszero & toggle[2] | ~up_i & down_i & ~islim & iszero & ~limit_i[2]),
        .nreset_i(nreset_i),
        .enable_i(clk_i),
        .q_o(count_o[2])
    );

    assign toggle[3] = toggle[2] & (count_o[2] & up_i | ~count_o[2] & down_i & ~up_i);
    FFJK FourthBit(
        .j_i(up_i & ~islim & toggle[3] | ~up_i & down_i & ~iszero & toggle[3] | ~up_i & down_i & ~islim & iszero & limit_i[3]),
        .k_i(islim & iszero | up_i & islim | up_i & ~islim & toggle[3] | ~up_i & down_i & ~iszero & toggle[3] | ~up_i & down_i & ~islim & iszero & ~limit_i[3]),
        .nreset_i(nreset_i),
        .enable_i(clk_i),
        .q_o(count_o[3])
    );

endmodule */

module Counter4Bit(
    input up_i,
    input down_i, // counts up if both up/down inputs are 1
    input counter_clk_i,
    input counter_nreset_i,
    input [3:0] limit_i,

    output [3:0] count_o,
    output islim_o,
    output iszero_o
    );

    wire [3:0] toggle;
    
    assign islim_o = (count_o == limit_i);
    assign iszero_o = (count_o == 4'b0000);


    genvar i;
    generate 
        for (i = 0; i < 4; i = i + 1) begin: JKFFArray
            assign toggle[i] = (i == 0? 1'b1 : toggle[i-1] & (count_o[i-1] & up_i | ~count_o[i-1] & down_i & ~up_i));
            FFJK JKFFInst(
                .j_i(up_i & ~islim_o & toggle[i] | ~up_i & down_i & ~iszero_o & toggle[i] | ~up_i & down_i & ~islim_o & iszero_o & limit_i[i]),
                .k_i(islim_o & iszero_o | up_i & islim_o | up_i & ~islim_o & toggle[i] | ~up_i & down_i & ~iszero_o & toggle[i] | ~up_i & down_i & ~islim_o & iszero_o & ~limit_i[i]),
                .nreset_i(counter_nreset_i),
                .enable_i(counter_clk_i),
                .q_o(count_o[i])
            );
        end
    endgenerate
endmodule

module DualBCDCounter(
    input dd_up_i,
    input dd_down_i, // counts up if both up/down inputs are 1
    input dd_clk_i,
    input dd_nreset_i,
    input [3:0] tens_limit_i, // if we want this thing to count from 0 to 23, then we input tens_limit_i a 2, and ones_limit_i a 3.
    input [3:0] ones_limit_i, // ones digit will only count up to 9 even if a greater limit is fed into this input
    // Tens digit can count higher than 9, if the given limit is higher than 9. 
    
    output [3:0] tens_count_o,
    output [3:0] ones_count_o, 
    output dd_carryup_o,
    output dd_carrydown_o
    );

    reg [3:0] ones_real_limit;
    wire ones_carryup, ones_carrydown;
    wire tens_islim, tens_iszero, ones_islim, ones_iszero;

    always @(*) begin
        if (tens_limit_i == 4'b0000) ones_real_limit <= ones_limit_i;
        else begin
            if (tens_islim & dd_up_i) // if ten is at limit and we are counting up. i.e. If inteded limit is 24 and we are counting 20, 21, 22...
                ones_real_limit <= ones_limit_i;
            else if (tens_iszero & ones_iszero & dd_down_i & ~dd_up_i) // if current count is at 00 and we are counting down. 
                ones_real_limit <= ones_limit_i;
            else ones_real_limit <= 4'b1001;
        end
    end

    assign ones_carryup = ones_islim & dd_up_i;
    assign ones_carrydown = ones_iszero & dd_down_i & ~dd_up_i;

    assign dd_carryup_o = tens_islim & ones_carryup;
    assign dd_carrydown_o = tens_iszero & ones_carrydown & ~ones_carryup;
    
    
    Counter4Bit OnesDigit(
        .up_i(dd_up_i),
        .down_i(dd_down_i),
        .counter_clk_i(dd_clk_i),
        .counter_nreset_i(dd_nreset_i),
        .limit_i(ones_real_limit),
        
        .count_o(ones_count_o),
        .islim_o(ones_islim),
        .iszero_o(ones_iszero)
    );

    Counter4Bit TensDigit(
        .up_i(ones_carryup),
        .down_i(ones_carrydown),
        .counter_clk_i(dd_clk_i),
        .counter_nreset_i(dd_nreset_i),
        .limit_i(tens_limit_i),

        .count_o(tens_count_o),
        .islim_o(tens_islim),
        .iszero_o(tens_iszero)
    );
endmodule

/* module Counter3Bit(
    input up_i,
    input down_i,
    input clk_i,
    input nreset_i,
    input [2:0] limit_i,

    output [2:0] count_o,
    output islim_o, // 1 if count == limit
    output iszero_o // 1 if count == 0000
    );

endmodule

module Counter2Bit(
    input up_i,
    input down_i,
    input clk_i,
    input nreset_i,
    input [1:0] limit_i,

    output [1:0] count_o,
    output islim_o, // 1 if count == limit
    output iszero_o // 1 if count == 0000
    );

endmodule

module FiftyNineCounter(
    input up59_i,
    input down59_i,
    input clk59_i,
    input nreset59_i,

    output [3:0] ones_digit59_o,
    output [2:0] tens_digit59_o,
    output carryup_o,
    output carrydown_o
    );

    wire ones_digit_iszero, ones_digit_isnine;
    wire tens_digit_iszero, tens_digit_isfive;

    assign carryup_o = up59_i & ones_digit_isnine & tens_digit_isfive;
    assign carrydown_o = down59_i & ones_digit_iszero & ones_digit_iszero;

    Counter4Bit OnesDigit(
        .up_i(up59_i),
        .down_i(down59_i),
        .clk_i(clk59_i),
        .nreset_i(nreset59_i),
        .limit_i(4'b1001),

        .count_o(ones_digit59_o),
        .islim_o(ones_digit_isnine),
        .iszero_o(ones_digit_iszero)
    );

    Counter3Bit TensDigit(
        .up_i(up59_i & ones_digit_isnine),
        .down_i(down59_i & ones_digit_iszero),
        .clk_i(clk59_i),
        .nreset_i(nreset59_i),
        .limit_i(3'b101),

        .count_o(tens_digit59_o),
        .islim_o(tens_digit_isfive),
        .iszero_o(tens_digit_iszero)
    );

endmodule

module NinetyNineCounter(
    input up99_i,
    input down99_i,
    input clk99_i,
    input nreset99_i,

    output [3:0] ones_digit99_o,
    output [3:0] tens_digit99_o,
    output carryup_o,
    output carrydown_o
    );

    wire ones_digit_iszero, ones_digit_isnine;
    wire tens_digit_iszero, tens_digit_isnine;

    assign carryup_o = up99_i & ones_digit_isnine & tens_digit_isnine;
    assign carrydown_o = down99_i & ones_digit_iszero & ones_digit_iszero;

    Counter4Bit OnesDigit(
        .up_i(up99_i),
        .down_i(down99_i),
        .clk_i(clk99_i),
        .nreset_i(nreset99_i),
        .limit_i(4'b1001),

        .count_o(ones_digit99_o),
        .islim_o(ones_digit_isnine),
        .iszero_o(ones_digit_iszero)
    );

    Counter4Bit TensDigit(
        .up_i(up99_i & ones_digit_isnine),
        .down_i(down99_i & ones_digit_iszero),
        .clk_i(clk99_i),
        .nreset_i(nreset99_i),
        .limit_i(4'b0101),

        .count_o(tens_digit99_o),
        .islim_o(tens_digit_isnine),
        .iszero_o(tens_digit_iszero)
    );

endmodule

module TwentyThreeCounter(
    input up23_i,
    input down23_i,
    input clk23_i,
    input nreset23_i,
    
    output reg [3:0] ones_digit23_o,
    output reg [1:0] tens_digit23_o
    );

    always @(posedge clk23_i or negedge nreset23_i) begin
        if (up23_i) begin
            if (tens_digit23_o == 2'b10) begin
                if (ones_digit23_o == 4'b0011) begin
                    ones_digit23_o <= 4'b0000;
                    tens_digit23_o <= 2'b00;
                end
                else begin
                    ones_digit23_o <= ones_digit23_o + 1;
                    tens_digit23_o <= tens_digit23_o;
                end
            end
            else begin
                if (ones_digit23_o == 4'b1001) begin
                    ones_digit23_o <= 4'b0000;
                    tens_digit23_o <= tens_digit23_o + 1;
                end
                else begin
                    ones_digit23_o <= ones_digit23_o + 1;
                    tens_digit23_o <= tens_digit23_o;
                end
            end
        end
        else if (down23_i) begin
            if (ones_digit23_o == 4'b0000) begin
                if (tens_digit23_o == 2'b00) begin
                    ones_digit23_o <= 4'b0011;
                    tens_digit23_o <= 2'b10;
                end
                else begin
                    ones_digit23_o <= 4'b1001;
                    tens_digit23_o <= tens_digit23_o - 1;
                end
            end
            else begin
                ones_digit23_o <= ones_digit23_o - 1;
                tens_digit23_o <= tens_digit23_o;
            end
        end
        else begin
            ones_digit23_o <= ones_digit23_o;
            tens_digit23_o <= tens_digit23_o;
        end

    end

endmodule */