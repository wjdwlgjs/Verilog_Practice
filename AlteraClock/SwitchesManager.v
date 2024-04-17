module ButtonInterpreter(
    input button_i,
    input clk_i,
    input nreset_i,
    
    output pressed_o
    );

    reg [1:0] state;

    always @(negedge clk_i or negedge nreset_i) begin
        if (~nreset_i) state <= 2'b00;
        else if (~button_i) 
            case (state)
                2'b00: state <= 2'b01;
                2'b01: state <= 2'b10;
                2'b10: state <= 2'b10;
                default: state <= 2'b00;
            endcase
        else state <= 2'b00;
    end

    assign pressed_o = (state == 2'b01);

endmodule

module digitdemux(
    input wire [3:0] a,
    input [1:0] sel,
    output reg [3:0] out_0,
    output reg [3:0] out_1,
    output reg [3:0] out_2,
    output reg [3:0] out_3
    );

    always @(*) begin
        case(sel) 
            2'b00: begin // clock
                out_0 = a;
                out_1 = 0;
                out_2 = 0;
                out_3 = 0;
            end
            2'b01: begin // stopwatch
                out_0 = 0;
                out_1 = a;
                out_2 = 0;
                out_3 = 0;
            end
            2'b10: begin // timer
                out_0 = 0;
                out_1 = 0;
                out_2 = a;
                out_3 = 0;
            end
            2'b11: begin // time setting?
                out_0 = 0;
                out_1 = 0; 
                out_2 = 0;
                out_3 = a;
            end
        endcase
    end
endmodule


module SwitchesManager(
    input key1_i,
    input key2_i,
    input key3_i,
    input set_switch_i,

    input clockmode_i,
    input stopwatchmode_i,
    input timermode_i,
    input clk_i,
    input nreset_i,
    
    output clock_set_run_switch_o, // set if 1, run if 0
    output clock_up_o, // key1
    output clock_down_o,  // key2
    output clock_setmode_o, // key3 set mode (sec, min, hr ) toggle
    
    // no output for switch, key1 for stopwatch
    output stopwatch_reset_o, // key2
    output stopwatch_runpause_o, // key3, run/pause toggle
    
    output timer_set_runorpause_switch_o, // set if 1, run or pause if 0
    output timer_up_o, // key1
    output timer_down_reset_o, // key2
    output timer_setmode_runpause_o // key3, set mode (sec, min, hr) toggle or run/pause toggle
    );

    wire [3:0] temp_outputs; // [0] for the switch, [1], [2], [3] for key1, key2, key3

    assign temp_outputs[0] = set_switch_i;

    ButtonInterpreter Key1Interpreter(
        .button_i(key1_i),
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .pressed_o(temp_outputs[1])
    );

    ButtonInterpreter Key2Interpreter(
        .button_i(key2_i),
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .pressed_o(temp_outputs[2])
    );

    ButtonInterpreter Key3Interpreter(
        .button_i(key3_i),
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .pressed_o(temp_outputs[3])
    );

    // assign {clock_setmode_o, clock_down_o, clock_up_o, clock_set_run_switch_o} = {4{clockmode_i}} & temp_outputs;
    //      key3             key2          key1,       switch
    // assign {stopwatch_runpause_o, stopwatch_reset_o} = {2{stopwatchmode_i}} & temp_outputs[3:2];
    //      key3                  key2
    // assign {timer_setmode_runpause_o, timer_down_reset_o, timer_up_o, timer_set_runorpause_switch_o} = {4{timermode_i}} & temp_outputs;
    //      key3                      key2                key1        switch

    wire [3:0] clock_signal, stopwatch_signal, timer_signal;
    
    digitdemux DigitDemux(
        .a(temp_outputs),
        .sel({timermode_i & ~clockmode_i, stopwatchmode_i & ~clockmode_i}),
        .out_0(clock_signal),
        .out_1(stopwatch_signal),
        .out_2(timer_signal),
        .out_3()
    );

    assign {clock_setmode_o, clock_down_o, clock_up_o, clock_set_run_switch_o} = clock_signal;
    assign {stopwatch_runpause_o, stopwatch_reset_o} = stopwatch_signal[3:2];
    assign {timer_setmode_runpause_o, timer_down_reset_o, timer_up_o, timer_set_runorpause_switch_o} = timer_signal;

endmodule
