`timescale 1ns/1ns

module tb_Counter4Bit();

    reg tb_clk;
    reg tb_nreset;
    wire [3:0] tb_count;

    Counter4Bit testCounter(
        .pulse_i(tb_clk),
        .count_nreset_i(tb_nreset),
        .count_o(tb_count)
    );

    initial begin
        tb_nreset = 0;
        tb_clk = 1;

        #5
        tb_clk = 0;
        tb_nreset = 1;

        #320
        tb_nreset = 0;
        tb_clk = 0;

        #10
        $stop;

    end
    always #8 tb_clk = ~tb_clk;

endmodule


        
