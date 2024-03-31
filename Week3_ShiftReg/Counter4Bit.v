module Counter4Bit(
    input pulse_i,
    input count_nreset_i,
    output [3:0] count_o
    );

    CustomDFF firstBit(
        .d_i(~count_o[0]),
        .clk_i(pulse_i),
        .nreset_i(count_nreset_i),
        .q_o(count_o[0])
    );

    CustomDFF secondBit(
        .d_i(~count_o[1]),
        .clk_i(~count_o[0]),
        .nreset_i(count_nreset_i),
        .q_o(count_o[1])
    );

    CustomDFF thirdBit(
        .d_i(~count_o[2]),
        .clk_i(~count_o[1]),
        .nreset_i(count_nreset_i),
        .q_o(count_o[2])
    );

    CustomDFF fourthBit(
        .d_i(~count_o[3]),
        .clk_i(~count_o[2]),
        .nreset_i(count_nreset_i),
        .q_o(count_o[3])
    );

endmodule