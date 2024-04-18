// `include "AlteraClock/ThreePhaseModeSelector.v"
// `include "AlteraClock/tb_Counters.v"

module ClockModule(
    // button inputs
    input set_run_switch_i,
    input up_i,
    input down_i,
    input setmode_i,

    output blink_sec_o,
    output blink_min_o,
    output blink_hr_o,

    // clk and nreset inputs
    input clk_i,
    input nreset_i,

    output [3:0] centisec_o,
    output [3:0] decisec_o,

    output [3:0] sec_o,
    output [3:0] decasec_o,

    output [3:0] min_o,
    output [3:0] decamin_o,

    output [3:0] hr_o,
    output [3:0] decahr_o
    );

    wire run;
    wire set_sec, set_min, set_hr;

    ThreePhaseModeSelector ClockController(
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .toggle_button_i(setmode_i), 
        .sync_nreset_i(set_run_switch_i),

        .initial_mode_o(run),
        .mode1_o(set_sec),
        .mode2_o(set_min),
        .mode3_o(set_hr)
    );

    wire lessthansec_carryup;
    DualBCDCounter LessThanSecCounter(
        .dd_up_i(run),
        .dd_down_i(1'b0),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i & run),
        .tens_limit_i(4'b1001),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decisec_o),
        .ones_count_o(centisec_o),
        .dd_carryup_o(lessthansec_carryup),
        .dd_carrydown_o()
    );

    wire sec_carryup;
    DualBCDCounter SecCounter(
        .dd_up_i(lessthansec_carryup & run | set_sec & up_i),
        .dd_down_i(set_sec & down_i),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i),
        .tens_limit_i(4'b0101),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decasec_o),
        .ones_count_o(sec_o),
        .dd_carryup_o(sec_carryup),
        .dd_carrydown_o()
    );

    wire min_carryup;
    DualBCDCounter MinCounter(
        .dd_up_i(sec_carryup & run | set_min & up_i),
        .dd_down_i(set_min & down_i),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i),
        .tens_limit_i(4'b0101),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decamin_o),
        .ones_count_o(min_o),
        .dd_carryup_o(min_carryup),
        .dd_carrydown_o()
    );

    wire hr_carryup;
    DualBCDCounter HrCounter(
        .dd_up_i(min_carryup & run | set_hr & up_i),
        .dd_down_i(set_hr & down_i),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i),
        .tens_limit_i(4'b0010),
        .ones_limit_i(4'b0011),
        
        .tens_count_o(decahr_o),
        .ones_count_o(hr_o),
        .dd_carryup_o(),
        .dd_carrydown_o()
    );

    assign blink_sec_o = set_sec;
    assign blink_min_o = set_min;
    assign blink_hr_o = set_hr;

endmodule