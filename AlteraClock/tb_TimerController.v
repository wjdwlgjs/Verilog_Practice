`include "AlteraClock/TimerModule.v"
`timescale 1ns/1ns

module tb_TimerController();

    reg [3:0] buttons_simulation;

    reg tb_set_runorpause_switch; 
    reg tb_up;
    reg tb_down_reset;
    reg tb_setmode_runpause;
    
    // timer innner control signals
    reg tb_everything_iszero;

    // clk and asynch (master) reset
    reg tb_clk;
    reg tb_nreset;

    wire tb_run;
    wire tb_manual_up;
    wire tb_manual_down;
    wire tb_notset_any;
    wire tb_set_sec;
    wire tb_set_min;
    wire tb_set_hr;
    wire tb_counters_nreset;
    wire tb_end_reached;

    always #10 tb_clk <= ~tb_clk;      

    TimerController TestController(
        .set_runorpause_switch_i(tb_set_runorpause_switch), 
        .up_i(tb_up),
        .down_reset_i(tb_down_reset),
        .setmode_runpause_i(tb_setmode_runpause),
        
        .everything_iszero_i(tb_everything_iszero),

        .clk_i(tb_clk),
        .nreset_i(tb_nreset),

        // timer control outputs
        .run_o(tb_run),
        .manual_up_o(tb_manual_up),
        .manual_down_o(tb_manual_down),
        .notset_any_o(tb_notset_any),
        .set_sec_o(tb_set_sec),
        .set_min_o(tb_set_min),
        .set_hr_o(tb_set_hr),
        .counters_nreset_o(tb_counters_nreset),
        .end_reached_o(tb_end_reached)
    );

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_TimerController.vcd");
        $dumpvars(0, tb_TimerController);

        tb_set_runorpause_switch = 0; 
        tb_up = 0;
        tb_down_reset = 0;
        tb_setmode_runpause = 0;
        buttons_simulation = 4'b0;
        
        // timer innner control signals
        tb_everything_iszero = 0;

        // clk and asynch (master) reset
        tb_clk = 0;
        tb_nreset = 0;

        #1
        tb_nreset = 1;

        #19

        for (integer i = 0; i < 20; i = i + 1) begin
            {tb_set_runorpause_switch, tb_up, tb_down_reset, tb_setmode_runpause, tb_everything_iszero} <= $random;
            buttons_simulation <= buttons_simulation + 1;

            #20;

        end

        $finish;
    end
endmodule
            
