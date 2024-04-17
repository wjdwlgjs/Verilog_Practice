`timescale 1ns/1ns
`include "AlteraClock/Counters.v"

module tb_Counters();

    /* reg tb_up;
    reg tb_down;
    reg tb_clk;
    reg tb_nreset;
    reg [3:0] tb_limit;

    wire [3:0] tb_count;
    wire tb_carryup;
    wire tb_carrydown;

    Counter4Bit TestCounter(
        .up_i(tb_up),
        .down_i(tb_down),
        .counter_clk_i(tb_clk),
        .counter_nreset_i(tb_nreset),
        .limit_i(tb_limit),
        .count_o(tb_count),
        .carryup_o(tb_carryup),
        .carrydown_o(tb_carrydown)
    );

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_Counters.vcd");
        $dumpvars(0, tb_Counters);
        tb_nreset = 0;
        tb_clk = 0;
        tb_limit = 4'b1001;
        tb_up = 0;
        tb_down = 0;
        #1
        tb_nreset = 1;

        #504
        tb_up = 1;

        #550
        tb_down = 1;

        #500 
        tb_up = 0;

        #500
        $finish;
    end
    always #10 tb_clk = ~tb_clk; */

    /* reg tb_up;
    reg tb_down;
    reg tb_clk;
    reg tb_nreset;
    reg [3:0] tb_tens_limit;
    reg [3:0] tb_ones_limit;

    wire [3:0] tb_tens_count;
    wire [3:0] tb_ones_count;
    wire tb_carryup;
    wire tb_carrydown;

    DualBCDCounter TestCounter(
        .dd_up_i(tb_up),
        .dd_down_i(tb_down),
        .dd_clk_i(tb_clk),
        .dd_nreset_i(tb_nreset),
        .tens_limit_i(tb_tens_limit),
        .ones_limit_i(tb_ones_limit),
        
        .tens_count_o(tb_tens_count),
        .ones_count_o(tb_ones_count),
        .dd_carryup_o(tb_carryup),
        .dd_carrydown_o(tb_carrydown)
    );

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_Counters.vcd");
        $dumpvars(0, tb_Counters);

        tb_nreset = 0;
        tb_clk = 0;
        tb_up = 0;
        tb_down = 0;
        tb_tens_limit = 0;
        tb_ones_limit = 0;

        #5
        tb_nreset = 1;
        
        #500
        tb_up = 1;

        #500
        tb_down = 1;

        #500
        tb_up = 0;

        #500
        tb_down = 0;
        tb_tens_limit = 4'b0010;

        #500
        tb_up = 1;

        #500
        tb_down = 1;

        #500
        tb_up = 0;

        #500
        tb_down = 0;
        tb_ones_limit = 4'b0011;

        #500
        tb_up = 1;

        #500
        tb_down = 1;

        #500
        tb_up = 0;

        #500
        tb_down = 0;
        tb_tens_limit = 4'b0000;

        #500
        $finish;
    end

    always #10 tb_clk = ~tb_clk; */
endmodule

        

