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

        #10
        tb_clk = 0;
        tb_nreset = 1;

        for (integer i = 0; i < 24; i = i + 1) begin
            #10;
            tb_clk = ~tb_clk;
        end

        #10
        tb_nreset = 0;
        tb_clk = 0;

        #10
        tb_clk = 0;

    end

endmodule


        
