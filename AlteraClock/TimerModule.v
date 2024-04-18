// `include "AlteraClock/Counters.v"

module TimerController(
    // button and switch inputs
    input set_runorpause_switch_i, // when switch is 1, it is set mode, when switch is 0, it is run/pause mode. similar to the clock module
    input up_i,
    input down_reset_i,
    input setmode_runpause_i,
    
    // timer innner control signals
    input everything_iszero_i,

    // clk and asynch (master) reset
    input clk_i,
    input nreset_i,

    // timer control outputs
    output run_o,
    output manual_up_o,
    output manual_down_o,
    output notset_any_o,
    output set_sec_o,
    output set_min_o,
    output set_hr_o,
    output counters_nreset_o,
    output end_reached_o
    );
    
    reg [2:0] control_state;
    localparam initial_state = 3'b000;
    localparam pause_state = 3'b001;
    localparam run_state = 3'b010;
    localparam end_state = 3'b011;
    localparam set_sec_state = 3'b101;
    localparam set_min_state = 3'b110;
    localparam set_hr_state = 3'b111;

    always @(posedge clk_i or negedge nreset_i) begin
        if (~nreset_i) control_state <= initial_state;
        else begin
            case (control_state) 
                initial_state: begin
                    if (set_runorpause_switch_i) control_state <= set_sec_state; // switch == 1, others: x
                    else control_state <= initial_state; // switch == 1, others: x
                end

                pause_state: begin
                    if (set_runorpause_switch_i) control_state <= set_sec_state; // switch == 1, others: x
                    else if (down_reset_i | everything_iszero_i) control_state <= initial_state; // switch == 0, down_reset or everything_iszero == 1, others: x
                    else if (setmode_runpause_i) control_state <= run_state; // switch == 0, down_reset == 0, everything_iszero == 0, setmode_runpause_i == 1, others: x
                    else control_state <= pause_state; // switch == 0, down_reset == 0, everything_zero == 0, setmode_runpause == 0, others: x
                end

                end_state: begin
                    if (set_runorpause_switch_i) control_state <= set_sec_state; // switch == 1, others: x
                    else if (up_i | down_reset_i | setmode_runpause_i) control_state <= initial_state; // switch == 0, any button == 1, others : 0
                    else control_state <= end_state; // switch == 0, all buttons : 0
                end

                run_state: begin
                    if (set_runorpause_switch_i) control_state <= set_sec_state; // switch == 1, others: x
                    else if (down_reset_i) control_state <= initial_state; // switch == 0, down_reset == 1, others: x
                    else if (everything_iszero_i) control_state <= end_state; // switch == 0, down_reset == 0, everything_iszero == 1, others: x
                    else if (setmode_runpause_i) control_state <= pause_state; // switch == 0, everything_iszero == 0, down_reset == 0, setmode_runpause == 1, others: x
                    else control_state <= run_state; // switch == 0, everything_iszero ==0, down_reset == 0, setmode_runpause == 0, others: x;
                end

                set_sec_state: begin
                    if (~set_runorpause_switch_i) begin
                        if (everything_iszero_i) control_state <= initial_state; // switch == 0, everything_iszero = 1, others: x
                        else control_state <= pause_state; // switch == 0, everything_iszero = 0, others: x
                    end
                    else if (setmode_runpause_i) control_state <= set_min_state; // switch == 1, setmode_runpause == 1, others: x
                    else control_state <= set_sec_state; // switch == 1, setmode_runpause == 0, others: x
                end

                set_min_state: begin
                    if (~set_runorpause_switch_i) begin
                        if (everything_iszero_i) control_state <= initial_state; // switch == 0, everything_iszero = 1, others: x
                        else control_state <= pause_state; // switch == 0, everything_iszero = 0, others: x
                    end
                    else if (setmode_runpause_i) control_state <= set_hr_state; // switch == 1, setmode_runpause == 1, others: x
                    else control_state <= set_min_state; // switch == 1, setmode_runpause == 0, others: x
                end

                set_hr_state: begin
                    if (~set_runorpause_switch_i) begin
                        if (everything_iszero_i) control_state <= initial_state; // switch == 0, everything_iszero = 1, others: x
                        else control_state <= pause_state; // switch == 0, everything_iszero = 0, others: x
                    end
                    else if (setmode_runpause_i) control_state <= set_sec_state; // switch == 1, setmode_runpause == 1, others: x
                    else control_state <= set_hr_state; // switch == 1, setmode_runpause == 0, others: x
                end
                default: control_state <= initial_state;
            endcase
        end
    end

    assign run_o = (control_state == run_state);
    assign manual_up_o = control_state[2] & up_i;
    assign manual_down_o = control_state[2] & down_reset_i;
    assign notset_any_o = ~control_state[2];
    assign set_sec_o = (control_state == set_sec_state);
    assign set_min_o = (control_state == set_min_state);
    assign set_hr_o = (control_state == set_hr_state);
    assign counters_nreset_o = ~((control_state == initial_state) | (control_state == end_state));
    assign end_reached_o = (control_state == end_state);

endmodule

module TimerModule(
    // button and switch inputs
    input set_runorpause_switch_i, // when switch is 1, it is set mode, when switch is 0, it is run/pause mode. similar to the clock module
    input up_i,
    input down_reset_i,
    input setmode_runpause_i,

    input clk_i,
    input nreset_i,

    output blink_lessthansec_o,
    output blink_sec_o,
    output blink_min_o,
    output blink_hr_o,

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
    wire manual_up;
    wire manual_down;
    wire notset_any;
    wire set_sec;
    wire set_min;
    wire set_hr;
    wire counters_nreset;
    wire end_reached;

    wire everything_iszero;
    assign everything_iszero = ({centisec_o, decisec_o, sec_o, decasec_o, min_o, decamin_o, hr_o, decahr_o} == 32'b0);

    TimerController Controller(
        // button and switch inputs
        .set_runorpause_switch_i(set_runorpause_switch_i), // when switch is 1, it is set mode, when switch is 0, it is run/pause mode. similar to the clock module
        .up_i(up_i),
        .down_reset_i(down_reset_i),
        .setmode_runpause_i(setmode_runpause_i),
        
        // timer innner control signals
        .everything_iszero_i(everything_iszero),

        // clk and asynch (master) reset
        .clk_i(clk_i),
        .nreset_i(nreset_i),

        // timer control outputs
        .run_o(run),
        .manual_up_o(manual_up),
        .manual_down_o(manual_down),
        .notset_any_o(notset_any),
        .set_sec_o(set_sec),
        .set_min_o(set_min),
        .set_hr_o(set_hr),
        .counters_nreset_o(counters_nreset),
        .end_reached_o(end_reached)
    );

    wire lessthansec_borrow;
    DualBCDCounter LessThanSecCounter(
        .dd_up_i(1'b0),
        .dd_down_i(run & ~everything_iszero),
        .dd_clk_i(clk_i),
        .dd_nreset_i(counters_nreset & notset_any),
        .tens_limit_i(4'b1001),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decisec_o),
        .ones_count_o(centisec_o),
        .dd_carryup_o(),
        .dd_carrydown_o(lessthansec_borrow)
    );

    wire sec_borrow;
    DualBCDCounter SecCounter(
        .dd_up_i(set_sec & manual_up),
        .dd_down_i(run & lessthansec_borrow | set_sec & manual_down),
        .dd_clk_i(clk_i),
        .dd_nreset_i(counters_nreset),
        .tens_limit_i(4'b0101),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decasec_o),
        .ones_count_o(sec_o),
        .dd_carryup_o(),
        .dd_carrydown_o(sec_borrow)
    );

    wire min_borrow;
    DualBCDCounter MinCounter(
        .dd_up_i(set_min & manual_up),
        .dd_down_i(run & sec_borrow | set_min & manual_down),
        .dd_clk_i(clk_i),
        .dd_nreset_i(counters_nreset),
        .tens_limit_i(4'b0101),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decamin_o),
        .ones_count_o(min_o),
        .dd_carryup_o(),
        .dd_carrydown_o(min_borrow)
    );

    DualBCDCounter HrCounter(
        .dd_up_i(set_hr & manual_up),
        .dd_down_i(run & min_borrow | set_hr & manual_down),
        .dd_clk_i(clk_i),
        .dd_nreset_i(counters_nreset),
        .tens_limit_i(4'b1001),
        .ones_limit_i(4'b1001),
        
        .tens_count_o(decahr_o),
        .ones_count_o(hr_o),
        .dd_carryup_o(),
        .dd_carrydown_o()
    );

    assign blink_lessthansec_o = end_reached;
    assign blink_sec_o = end_reached | set_sec;
    assign blink_min_o = end_reached | set_min;
    assign blink_hr_o = end_reached | set_hr;
endmodule
