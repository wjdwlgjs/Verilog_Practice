`include "MotorController3/UARTDebugger.v"
`timescale 1ns/1ns

module tb_UARTDebugger();
    reg tb_clk;
    reg tb_nreset;

    reg [135:0] tb_written_values;
    reg [31:0] tb_sensor_data;
    reg tb_initiate;
    reg [167:0] recieved_data;

    wire tb_tx;

    UARTDebugger TestDebugger(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .written_values_i(tb_written_values),
        .sensor_data_i(tb_sensor_data),
        .initiate_i(tb_initiate),
        .tx_o(tb_tx)
    );

    always #18.5 tb_clk = ~tb_clk;

    always @(posedge tb_initiate) #125 tb_initiate = 0;


    initial begin
        $dumpfile("MotorController3/BuildFiles/tb_UARTDebugger.vcd");
        $dumpvars(0, tb_UARTDebugger);

        tb_clk = 0;
        tb_nreset = 0;

        tb_written_values = $random;
        tb_sensor_data = $random;
        tb_initiate = 0;

        #100 
        tb_nreset = 1;

        #300 tb_initiate = 1;
        /* for (integer i = 0; i < 21; i = i + 1) begin
            for (integer j = 0; j < 8; j = j + 1) begin
                 */

        #104167000
        $finish;
    end

endmodule




