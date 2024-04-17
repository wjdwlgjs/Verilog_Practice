`include "AlteraClock/ClockModule.v"
`timescale 1ns/1ns

module tb_ClockModule();

    reg tb_set_run_switch;
    reg tb_up;
    reg tb_down;
    reg tb_setmode;

    reg tb_clk;
    reg tb_nreset;

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
    wire [3:0] tb_decahr_o;

    ClockModule TestClockModule(
        .set_run_switch_i(tb_set_run_switch),
        .up_i(tb_up),
        .down_i(tb_down),
        .setmode_i(tb_setmode),

        .clk_i(tb_clk),
        .nreset_i(tb_nreset),

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
        .decahr_o(tb_decahr_o)
    );

    always @(posedge tb_clk) #9 {tb_up, tb_down, tb_setmode} <= 3'b000;
    always #10 tb_clk <= ~tb_clk;


    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_ClockModule.vcd");
        $dumpvars(0, tb_ClockModule);

        tb_set_run_switch = 0;
        tb_up = 0;
        tb_down = 0;
        tb_setmode = 0;

        tb_clk = 0;
        tb_nreset = 0;

        #20
        tb_nreset = 1;

        #7337000

        tb_set_run_switch = 1;

        #80
        tb_up = 1;

        #80
        tb_down = 1;

        #80
        tb_setmode = 1;

        #80
        tb_up = 1;

        #80
        tb_down = 1;

        #80
        tb_setmode = 1;

        #80
        tb_up = 1;

        #80
        tb_down = 1;

        #80
        tb_setmode = 1;

        #80
        tb_up = 1;

        #80
        tb_down = 1;
        
        #80
        tb_setmode = 0;

        #80
        $finish;
    end
endmodule
