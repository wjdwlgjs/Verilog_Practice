`include "MotorController3/UltraSoundInterface.v"
`timescale 1ns/1ns

module tb_UltraSoundInterface();

    reg tb_clk;
    reg tb_nreset;

    reg tb_echo;

    wire tb_trig;
    wire [31:0] tb_dist;

    UltraSoundInterface TestInterface(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),

        .echo_i(tb_echo),

        .trig_o(tb_trig),
        .dist_o(tb_dist)
    );

    always #18.5 tb_clk = ~tb_clk;

    always @(negedge tb_trig) #13000 begin
        tb_echo = 1;
        #100000;
        tb_echo = 0;
    end

    initial begin
        $dumpfile("MotorController3/BuildFiles/tb_UltraSoundInterface.vcd");
        $dumpvars(0, tb_UltraSoundInterface);
        tb_clk = 0;
        tb_nreset = 0;

        tb_echo = 0;

        #100
        tb_nreset = 1;

        #100000000;
        $finish;
    end


endmodule
        