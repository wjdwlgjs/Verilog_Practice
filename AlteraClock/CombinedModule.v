/* `include "AlteraClock/SwitchesManager.v"
`include "AlteraClock/ClockModule.v"
`include "AlteraClock/StopWatchModule.v"
`include "AlteraClock/TimerModule.v"
`include "AlteraClock/OutputManager.v"
`include "AlteraClock/ThreePhaseModeSelector.v" */


module CombinedModule( // button input manager + clock + stopwatch + timer + output decoder + output manager
    input key0_i,
    input key1_i,
    input key2_i,
    input key3_i,
    input set_switch_i,
    input disp_on_switch_i,

    input clk_i,
    input nreset_i,

    output [6:0] centisec_7seg_o,
    output [6:0] decisec_7seg_o,

    output [6:0] sec_7seg_o,
    output [6:0] decasec_7seg_o,
    
    output [6:0] min_7seg_o,
    output [6:0] decamin_7seg_o,

    output [6:0] hr_7seg_o,
    output [6:0] decahr_7seg_o,

    output blink_lessthansec_o,
    output blink_sec_o,
    output blink_min_o,
    output blink_hr_o
    );

    wire display_mode_toggle;

    ButtonInterpreter ModeSelectButtonInterpreter(
        .button_i(key0_i),
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        
        .pressed_o(display_mode_toggle)
    );

    wire dispoffmode;
    wire clockmode;
    wire stopwatchmode;
    wire timermode;

    ThreePhaseModeSelector DisplayModeManager(
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .toggle_button_i(display_mode_toggle), 
        .sync_nreset_i(disp_on_switch_i),

        .initial_mode_o(dispoffmode),
        .mode1_o(clockmode),
        .mode2_o(stopwatchmode),
        .mode3_o(timermode)
    );

    wire clock_set_run_switch, clock_up, clock_down, clock_setmode;
    wire stopwatch_reset, stopwatch_runpause;
    wire timer_set_runorpause_switch, timer_up, timer_down_reset, timer_setmode_runpause;

    SwitchesManager TestManager(
        .key1_i(key1_i),
        .key2_i(key2_i),
        .key3_i(key3_i),
        .set_switch_i(set_switch_i),

        .clockmode_i(clockmode),
        .stopwatchmode_i(stopwatchmode),
        .timermode_i(timermode),
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        
        .clock_set_run_switch_o(clock_set_run_switch), 
        .clock_up_o(clock_up), 
        .clock_down_o(clock_down),  
        .clock_setmode_o(clock_setmode), 
        
        .stopwatch_reset_o(stopwatch_reset),
        .stopwatch_runpause_o(stopwatch_runpause), 
        
        .timer_set_runorpause_switch_o(timer_set_runorpause_switch), 
        .timer_up_o(timer_up), 
        .timer_down_reset_o(timer_down_reset), 
        .timer_setmode_runpause_o(timer_setmode_runpause)
    );

    wire clock_blink_sec, clock_blink_min, clock_blink_hr;
    wire [3:0] clock_centisec, clock_decisec, clock_sec, clock_decasec, clock_min, clock_decamin, clock_hr, clock_decahr;
    ClockModule MainClock(
        .set_run_switch_i(clock_set_run_switch),
        .up_i(clock_up),
        .down_i(clock_down),
        .setmode_i(clock_setmode),

        .blink_sec_o(clock_blink_sec),
        .blink_min_o(clock_blink_min),
        .blink_hr_o(clock_blink_hr),

        // clk and nreset inputs
        .clk_i(clk_i),
        .nreset_i(nreset_i),

        .centisec_o(clock_centisec),
        .decisec_o(clock_decisec),

        .sec_o(clock_sec),
        .decasec_o(clock_decasec),

        .min_o(clock_min),
        .decamin_o(clock_decamin),

        .hr_o(clock_hr),
        .decahr_o(clock_decahr)
    );

    wire [3:0] stopwatch_centisec, stopwatch_decisec, stopwatch_sec, stopwatch_decasec, stopwatch_min, stopwatch_decamin, stopwatch_hr, stopwatch_decahr;
    StopWatchModule MainStopWatch(
        .run_pause_button_i(stopwatch_runpause),
        .stopwatch_reset_i(stopwatch_reset), 
        .clk_i(clk_i),
        .nreset_i(nreset_i),

        .centisec_o(stopwatch_centisec),
        .decisec_o(stopwatch_decisec),

        .sec_o(stopwatch_sec),
        .decasec_o(stopwatch_decasec),

        .min_o(stopwatch_min),
        .decamin_o(stopwatch_decamin),

        .hr_o(stopwatch_hr),
        .decahr_o(stopwatch_decahr)
    );

    wire timer_blink_lessthansec, timer_blink_sec, timer_blink_min, timer_blink_hr;
    wire [3:0] timer_centisec, timer_decisec, timer_sec, timer_decasec, timer_min, timer_decamin, timer_hr, timer_decahr;

    TimerModule MainTimer(
        .set_runorpause_switch_i(timer_set_runorpause_switch),
        .up_i(timer_up),
        .down_reset_i(timer_down_reset),
        .setmode_runpause_i(timer_setmode_runpause),

        .clk_i(clk_i),
        .nreset_i(nreset_i),

        .blink_lessthansec_o(timer_blink_lessthansec),
        .blink_sec_o(timer_blink_sec),
        .blink_min_o(timer_blink_min),
        .blink_hr_o(timer_blink_hr),

        .centisec_o(timer_centisec),
        .decisec_o(timer_decisec),

        .sec_o(timer_sec),
        .decasec_o(timer_decasec),

        .min_o(timer_min),
        .decamin_o(timer_decamin),

        .hr_o(timer_hr),
        .decahr_o(timer_decahr)
    );

    digitdiplmux OutputManager(
        .clk(clk_i),
        .rstn(nreset_i),
        .clock_values({clock_centisec, clock_decisec, clock_sec, clock_decasec, clock_min, clock_decamin, clock_hr, clock_decahr}),
        .stopwatch_values({stopwatch_centisec, stopwatch_decisec, stopwatch_sec, stopwatch_decasec, stopwatch_min, stopwatch_decamin, stopwatch_hr, stopwatch_decahr}),
        .timer_values({timer_centisec, timer_decisec, timer_sec, timer_decasec, timer_min, timer_decamin, timer_hr, timer_decahr}),
        .clockmode(clockmode),
        .stopwatchmode(stopwatchmode),
        .timermode(timermode),

        .segment_out({decahr_7seg_o, hr_7seg_o, decamin_7seg_o, min_7seg_o, decasec_7seg_o, sec_7seg_o, decisec_7seg_o, centisec_7seg_o})
    );

    assign blink_lessthansec_o = timer_blink_lessthansec & timermode;
    assign blink_sec_o = clock_blink_sec & clockmode | timer_blink_sec & timermode;
    assign blink_min_o = clock_blink_min & clockmode | timer_blink_min & timermode;
    assign blink_hr_o = clock_blink_hr & clockmode | timer_blink_hr & timermode;
endmodule