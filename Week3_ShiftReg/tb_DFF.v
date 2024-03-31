`timescale 1ns/1ns

module  tb_DFF();
    reg tb_clk;
    reg tb_d;
    reg tb_nreset;
    wire tb_q;

    CustomDFF DFlipflop(
        .d_i(tb_d),
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .q_o(tb_q)
    );

    initial begin
        tb_nreset = 1'b0;
        $dumpfile("tb_DFF.vcd");
        $dumpvars(0,tb_DFF);
        $monitor("time: %0d, tb_clk: %b, tb_d: %b, tb_q: %b", $time, tb_clk, tb_d, tb_q);

        tb_clk = 1;
        tb_d = 0;
       
        #10
        tb_nreset = 1'b1;

        #10
        tb_d = 1'b1;

        #10
        tb_d = 1'b0;

        #10
        tb_d = 1'b1;

        #10
        tb_d = 1'b0;

        #10
        tb_d = 1'b1;
       
        #10
        tb_d = 1'b0;

        #10
        tb_d = 1'b0;

        #10
        tb_d = 1'b1;

        #10
        tb_d = 1'b1;

        #10
        tb_d = 1'b0;

        #5
        tb_d = 1'b0;

        #10
        tb_d = 1'b0;

        #10
        tb_d = 1'b1;

        #10
        tb_d = 1'b1;

        #10
        tb_d = 1'b0;

        #10
        $stop;
        
    end 
    always #8 tb_clk = ~tb_clk;
    
endmodule
