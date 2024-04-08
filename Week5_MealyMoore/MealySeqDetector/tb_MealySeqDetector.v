`timescale 1ns/1ns

module tb_MealySeqDetector();

    reg tb_in;
    reg tb_clk;
    reg tb_nreset;
    wire tb_out;

    MealySeqDetector TestDetector(
        .in_i(tb_in),
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .out_o(tb_out)
    );

    initial begin
        $dumpfile("tb_MealySeqDetector.vcd");
        $dumpvars(0, tb_MealySeqDetector);

        tb_in = 0;
        tb_clk = 0;
        tb_nreset = 0;

        #5
        tb_nreset = 1;

        tb_in = 0;
        #20
        
        tb_in = 1;
        #20
        
        tb_in = 1;
        #20
        
        tb_in = 0;
        #20
        
        tb_in = 1;
        #20
        
        tb_in = 0;
        #20
        
        tb_in = 1; 
        #20
        
        tb_in = 0;
        #20
        
        tb_in = 1;
        #20
        
        tb_in = 1;
        #20
        
        tb_in = 0;
        #20
        
        tb_in = 0;
        #20
        
        tb_in = 1;
        #20

        tb_nreset = 0;
        #20

        $stop;
    end

    always #10 tb_clk = ~tb_clk;
endmodule
