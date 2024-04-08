`timescale 1ns/1ns

module tb_MooreCounter();

    reg tb_in;
    reg tb_clk;
    reg tb_nreset;
    wire [1:0] tb_count;

    MooreCounter TestCounter(
        .in_i(tb_in),
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .count_o(tb_count)
    );

    initial begin
        $dumpfile("tb_MooreCounter.vcd");
        $dumpvars(tb_MooreCounter, 0);

        tb_nreset = 0;
        tb_clk = 0;
        tb_in = 0;

        #5
        tb_nreset = 1;
        tb_in = 1;

        #100
        tb_in = 0;

        #100
        tb_nreset = 0;
        $stop;
    end

    always #10 tb_clk = ~tb_clk;
endmodule

