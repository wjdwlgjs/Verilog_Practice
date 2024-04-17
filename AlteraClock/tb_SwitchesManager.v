`timescale 1ns/1ns
`include "AlteraClock/SwitchesManager.v"

module tb_SwitchesManager();

    reg tb_key1;
    reg tb_key2;
    reg tb_key3;
    reg tb_set_switch;

    reg tb_clockmode;
    reg tb_stopwatchmode;
    reg tb_timermode;
    reg tb_clk;
    reg tb_nreset;
    
    wire tb_clock_set_run_switch; // set if 1, run if 0
    wire tb_clock_up; // key1
    wire tb_clock_down;  // key2
    wire tb_clock_setmode; // key3 set mode (sec, min, hr ) toggle
    
    wire tb_stopwatch_reset; // key2
    wire tb_stopwatch_runpause; // key3, run/pause toggle
    
    wire tb_timer_set_runorpause_switch; // set if 1, run or pause if 0
    wire tb_timer_up; // key1
    wire tb_timer_down_reset; // key2
    wire tb_timer_setmode_runpause; // key3, set mode (sec, min, hr) toggle or run/pause toggle

    SwitchesManager TestManager(
        .key1_i(tb_key1),
        .key2_i(tb_key2),
        .key3_i(tb_key3),
        .set_switch_i(tb_set_switch),

        .clockmode_i(tb_clockmode),
        .stopwatchmode_i(tb_stopwatchmode),
        .timermode_i(tb_timermode),
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        
        .clock_set_run_switch_o(tb_clock_set_run_switch), 
        .clock_up_o(tb_clock_up), 
        .clock_down_o(tb_clock_down),  
        .clock_setmode_o(tb_clock_setmode), 
        
        .stopwatch_reset_o(tb_stopwatch_reset),
        .stopwatch_runpause_o(tb_stopwatch_runpause), 
        
        .timer_set_runorpause_switch_o(tb_timer_set_runorpause_switch), 
        .timer_up_o(tb_timer_up), 
        .timer_down_reset_o(tb_timer_down_reset), 
        .timer_setmode_runpause_o(tb_timer_setmode_runpause)
    );

    always #10 tb_clk <= ~tb_clk;

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_SwitchesManager.vcd");
        $dumpvars(0, tb_SwitchesManager);

        tb_key1 = 0;
        tb_key2 = 0;
        tb_key3 = 0;
        tb_set_switch = 0;

        tb_clockmode = 0;
        tb_stopwatchmode = 0;
        tb_timermode = 0;
        tb_clk = 0;
        tb_nreset = 0;

        #2
        tb_nreset = 1;

        for (integer i = 0; i < 18; i = i + 1) begin
            #50;
            {tb_key1, tb_key2, tb_key3, tb_set_switch} = {tb_key1, tb_key2, tb_key3, tb_set_switch} + 1;
        end
        
        tb_key1 = 0;
        tb_key2 = 0;
        tb_key3 = 0;
        tb_set_switch = 0;
        tb_clockmode = 1;
        tb_stopwatchmode = 0;
        tb_timermode = 0;
        for (integer i = 0; i < 18; i = i + 1) begin
            #50;
            {tb_key1, tb_key2, tb_key3, tb_set_switch} = {tb_key1, tb_key2, tb_key3, tb_set_switch} + 1;
        end

        tb_key1 = 0;
        tb_key2 = 0;
        tb_key3 = 0;
        tb_set_switch = 0;
        tb_clockmode = 0;
        tb_stopwatchmode = 1;
        tb_timermode = 0;
        for (integer i = 0; i < 18; i = i + 1) begin
            #50;
            {tb_key1, tb_key2, tb_key3, tb_set_switch} = {tb_key1, tb_key2, tb_key3, tb_set_switch} + 1;
        end

        tb_key1 = 0;
        tb_key2 = 0;
        tb_key3 = 0;
        tb_set_switch = 0;
        tb_clockmode = 0;
        tb_stopwatchmode = 0;
        tb_timermode = 1;
        for (integer i = 0; i < 18; i = i + 1) begin
            #50;
            {tb_key1, tb_key2, tb_key3, tb_set_switch} = {tb_key1, tb_key2, tb_key3, tb_set_switch} + 1;
        end
        $finish;
    end
endmodule

