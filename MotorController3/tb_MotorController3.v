`include "MotorController3/MotorController3.v"
`timescale 1ns/1ns

module tb_MotorController3();

    reg tb_clk;
    reg tb_nreset;

    reg tb_rx;
    wire tb_tx;

    reg [7:0] mode;
    reg [31:0] desired_value;
    reg [31:0] tb_k_p;
    reg [31:0] tb_k_i;
    reg [31:0] tb_k_d;

    reg [135:0] data_to_send;


    MotorController3 ControllerInst(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .rx_i(tb_rx),
        .tx_o(tb_tx)
    );

    always #18.5 tb_clk = ~tb_clk;

    initial begin
        $dumpfile("MotorController3/BuildFiles/tb_MotorController3.vcd");
        $dumpvars(0, tb_MotorController3);

        tb_clk = 0;
        tb_nreset = 0;
        tb_rx = 1;

        mode = 8'b00001001;

        desired_value = $random;
        tb_k_p = $random;
        tb_k_i = $random;
        tb_k_d = $random;

        data_to_send = {tb_k_d, tb_k_i, tb_k_p, desired_value, mode};

        #300 
        tb_nreset = 1;
        #1000

        for (integer i = 0; i < 17; i = i + 1) begin
            tb_rx = 0;
            #104167;
            for (integer j = 0; j < 8; j = j + 1) begin
                tb_rx = data_to_send[0];
                data_to_send = {data_to_send[0], data_to_send[135:1]};
                #104167;
            end
            tb_rx = 1;
            #104167;
        end

        #100000000;

        $finish;

    end





endmodule