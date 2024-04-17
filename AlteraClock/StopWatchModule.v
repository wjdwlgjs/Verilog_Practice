`include "AlteraClock/Counters.v" // includes ffjk too

module StopWatchModule(
    // button inputs
    // no controller needed
    input run_pause_button_i,
    input stopwatch_reset_i, // reset button

    // clock and master asynchronous reset inputs
    input clk_i,
    input nreset_i,

    // outputs
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

    FFJK run_pause_controller(
        .j_i(run_pause_button_i),
        .k_i(run_pause_button_i),
        .nreset_i(nreset_i & ~stopwatch_reset_i),
        .enable_i(clk_i),

        .q_o(run)
    );

    wire sec_countup;
    DualBCDCounter LessThanSecCounter(
        .dd_up_i(run),
        .dd_down_i(1'b0),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i & ~stopwatch_reset_i),
        .tens_limit_i(4'b1001),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decisec_o),
        .ones_count_o(centisec_o),
        .dd_carryup_o(sec_countup),
        .dd_carrydown_o()
    );

    wire min_countup;
    DualBCDCounter SecCounter(
        .dd_up_i(sec_countup),
        .dd_down_i(1'b0),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i & ~stopwatch_reset_i),
        .tens_limit_i(4'b0101),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decasec_o),
        .ones_count_o(sec_o),
        .dd_carryup_o(min_countup),
        .dd_carrydown_o()
    );

    wire hr_countup;
    DualBCDCounter MinCounter(
        .dd_up_i(min_countup),
        .dd_down_i(1'b0),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i & ~stopwatch_reset_i),
        .tens_limit_i(4'b0101),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decamin_o),
        .ones_count_o(min_o),
        .dd_carryup_o(hr_countup),
        .dd_carrydown_o()
    );

    DualBCDCounter HrCounter(
        .dd_up_i(hr_countup),
        .dd_down_i(1'b0),
        .dd_clk_i(clk_i),
        .dd_nreset_i(nreset_i & ~stopwatch_reset_i),
        .tens_limit_i(4'b1001),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decahr_o),
        .ones_count_o(hr_o),
        .dd_carryup_o(),
        .dd_carrydown_o()
    );

endmodule