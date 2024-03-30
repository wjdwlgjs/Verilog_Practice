module ShiftReg2(
    input sdi_i,
    input reg_clk_i,
    input reg_nreset_i,
    output [3:0] pdo_o,
    output sdo_o
    );

    CustomDFF dff_inst0(
        .d_i(sdi_i),
        .clk_i(~reg_clk_i),
        .nreset_i(reg_nreset_i),
        .q_o(pdo_o[0])
    );

    CustomDFF dff_inst1(
        .d_i(pdo_o[0]),
        .clk_i(~reg_clk_i),
        .nreset_i(reg_nreset_i),
        .q_o(pdo_o[1])
    );

    CustomDFF dff_inst2(
        .d_i(pdo_o[1]),
        .clk_i(~reg_clk_i),
        .nreset_i(reg_nreset_i),
        .q_o(pdo_o[2])
    );

    CustomDFF dff_inst3(
        .d_i(pdo_o[2]),
        .clk_i(~reg_clk_i),
        .nreset_i(reg_nreset_i),
        .q_o(pdo_o[3])
    );

    assign sdo_o = pdo_o[3];

endmodule