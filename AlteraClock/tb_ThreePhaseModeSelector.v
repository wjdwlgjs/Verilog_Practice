`timescale 1ns/1ns
`include "AlteraClock/ThreePhaseModeSelector.v"

module tb_ThreePhaseModeSelector();

    reg tb_clk;
    reg tb_nreset;
    reg tb_toggle_button; 
    reg tb_button_activate;
    reg tb_sync_nreset;

    wire tb_initial_mode;
    wire tb_mode1;
    wire tb_mode2;
    wire tb_mode3;

    ThreePhaseModeSelector test_selector(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .toggle_button_i(tb_toggle_button & tb_button_activate), 
        .sync_nreset_i(tb_sync_nreset),

        .initial_mode_o(tb_initial_mode),
        .mode1_o(tb_mode1),
        .mode2_o(tb_mode2),
        .mode3_o(tb_mode3)
    );

    always @(negedge tb_clk) tb_toggle_button <= ~tb_toggle_button;
    always #10 tb_clk <= ~tb_clk;

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_ThreePhaseModeSelector.vcd");
        $dumpvars(0, tb_ThreePhaseModeSelector);

        tb_clk = 0;
        tb_nreset = 0;
        tb_toggle_button = 0; 
        tb_button_activate = 0;
        tb_sync_nreset = 0;

        #32 
        tb_nreset = 1;

        #50 
        tb_sync_nreset = 1;

        #100 tb_button_activate = 1;
        #1000 tb_sync_nreset = 0;

        #1000
        $finish;
    end
endmodule
