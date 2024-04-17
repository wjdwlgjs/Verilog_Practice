`include "AlteraClock/PulseGenerator.v"
`timescale 10ns/10ns

module tb_PulseGenerator();

    reg tb_clk;
    reg tb_nreset;
    
    wire tb_pulse;

    always #1 tb_clk <= ~tb_clk;

    PulseGenerator testPulseGen(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .period_i(32'b11100010), // 111101000010010000
        
        .pulse_o(tb_pulse)
    );

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_PulseGenerator.vcd");
        $dumpvars(0, tb_PulseGenerator);

        tb_nreset = 0;
        tb_clk = 0;

        #1
        tb_nreset = 1;

        #1000000
        tb_nreset = 0;
        $finish;
    end
endmodule