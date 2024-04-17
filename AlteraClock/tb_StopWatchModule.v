`timescale 1ns/1ns
`include "AlteraClock/StopWatchModule.v"

module tb_StopWatchModule();

    reg tb_run_pause_button;
    reg tb_reset_button;

    reg tb_clk;
    reg tb_nreset;

    wire [3:0] tb_centisec;
    wire [3:0] tb_decisec;

    wire [3:0] tb_sec;
    wire [3:0] tb_decasec;

    wire [3:0] tb_min;
    wire [3:0] tb_decamin;

    wire [3:0] tb_hr;
    wire [3:0] tb_decahr;

    StopWatchModule TestStopWatch(
        .run_pause_button_i(tb_run_pause_button),
        .stopwatch_reset_i(tb_reset_button), 
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),

        .centisec_o(tb_centisec),
        .decisec_o(tb_decisec),

        .sec_o(tb_sec),
        .decasec_o(tb_decasec),

        .min_o(tb_min),
        .decamin_o(tb_decamin),

        .hr_o(tb_hr),
        .decahr_o(tb_decahr)
    );

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_StopWatchModule.vcd");
        $dumpvars(0, tb_StopWatchModule);

        tb_nreset = 0;
        tb_clk = 0;
        tb_run_pause_button = 0;
        tb_reset_button = 0;

        #1
        tb_nreset = 1;
        tb_run_pause_button = 1;

        #10
        tb_run_pause_button = 0;

        #3600100
        tb_run_pause_button = 1;

        #10
        tb_run_pause_button = 0;

        #100
        tb_run_pause_button = 1;

        #10
        tb_run_pause_button = 0;

        #100
        tb_reset_button = 1;

        #10 
        tb_reset_button = 0;

        #100
        $finish;
    end

    always #5 tb_clk = ~tb_clk;

endmodule