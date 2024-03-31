`timescale 1ns/1ns

module tb_ShiftReg();

    reg tb_clk;
    reg tb_nreset;
    reg tb_sdi; // serial data in
    wire tb_sdo; // serial data out
    wire [3:0] tb_pdo; // parallel data out

    ShiftReg2 testShiftReg(
        .sdi_i(tb_sdi),
        .reg_clk_i(tb_clk),
        .reg_nreset_i(tb_nreset),
        .pdo_o(tb_pdo),
        .sdo_o(tb_sdo)
    );

    initial begin
        $dumpfile("tb_ShiftReg.vcd");
        $dumpvars(0, tb_ShiftReg);

        tb_clk = 1'b0;
        tb_nreset = 1'b0;
        tb_sdi = 1'b0;

        #5
        tb_nreset = 1'b1;

        #5
        tb_sdi = 1'b1;

        #40
        tb_sdi = 1'b0;

        #16
        tb_sdi = 1'b1;

        #16
        tb_sdi = 1'b0;

        #8
        tb_sdi = 1'b1;

        #8
        tb_sdi = 1'b0;

        #8
        tb_sdi = 1'b1;

        #8
        tb_sdi = 1'b0;

        #8
        tb_nreset = 0; 

        #8
        tb_nreset = 0;
        $stop;
    end

    always #8 tb_clk = ~tb_clk;

endmodule
