`include "AlteraClock/TimerModule.v"
`timescale 1ns/1ns

module tb_TimerModule();
    reg tb_set_runorpause_switch;
    reg tb_up;
    reg tb_down_reset;
    reg tb_setmode_runpause;

    reg tb_clk;
    reg tb_nreset;

    wire tb_blink_lessthansec;
    wire tb_blink_sec;
    wire tb_blink_min;
    wire tb_blink_hr;

    wire [3:0] tb_centisec;
    wire [3:0] tb_decisec;

    wire [3:0] tb_sec;
    wire [3:0] tb_decasec;

    wire [3:0] tb_min;
    wire [3:0] tb_decamin;

    wire [3:0] tb_hr;
    wire [3:0] tb_decahr;

    TimerModule TestTimer(
        .set_runorpause_switch_i(tb_set_runorpause_switch),
        .up_i(tb_up),
        .down_reset_i(tb_down_reset),
        .setmode_runpause_i(tb_setmode_runpause),

        .clk_i(tb_clk),
        .nreset_i(tb_nreset),

        .blink_lessthansec_o(tb_blink_lessthansec),
        .blink_sec_o(tb_blink_sec),
        .blink_min_o(tb_blink_min),
        .blink_hr_o(tb_blink_hr),

        .centisec_o(tb_centisec),
        .decisec_o(tb_decisec),

        .sec_o(tb_sec),
        .decasec_o(tb_decasec),

        .min_o(tb_min),
        .decamin_o(tb_decamin),

        .hr_o(tb_hr),
        .decahr_o(tb_decahr)
    );

    always @(posedge tb_clk) #9 {tb_up, tb_down_reset, tb_setmode_runpause} <= 3'b000;
    always #10 tb_clk <= ~tb_clk;

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_TimerModule");
        $dumpvars(0, tb_TimerModule);

        tb_set_runorpause_switch = 0;
        tb_up = 0;
        tb_down_reset = 0;
        tb_setmode_runpause = 0;

        tb_clk = 0;
        tb_nreset = 0;

        #20
        tb_nreset = 1;

        #120
        tb_set_runorpause_switch = 1;
        #120
        tb_up = 1;
        #20
        tb_up = 1;
        #80
        tb_down_reset = 1;

        #120
        tb_setmode_runpause = 1;
        #120
        tb_up = 1;
        #20
        tb_up = 1;
        #80
        tb_down_reset = 1;

        #120
        tb_setmode_runpause = 1;
        #120
        tb_up = 1;
        #20
        tb_up = 1;
        #80
        tb_down_reset = 1;

        #120
        tb_setmode_runpause = 1;

        #120
        tb_set_runorpause_switch = 0;
        
        #120
        tb_setmode_runpause = 1;

        #7337000
        $finish;
    end
endmodule