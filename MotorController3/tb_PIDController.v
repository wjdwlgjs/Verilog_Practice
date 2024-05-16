`include "MotorController3/PIDController.v"
`timescale 1ns/1ns

module tb_PIDController();
    reg [31:0] tb_k_p;
    reg [31:0] tb_k_i;
    reg [31:0] tb_k_d;

    reg [31:0] tb_desired_value;
    reg [31:0] tb_current_state;

    reg tb_clk;
    reg tb_nreset;

    wire [15:0] tb_pid_throttle;


    PIDController TestController(
        .k_p_i(tb_k_p),
        .k_i_i(tb_k_i),
        .k_d_i(tb_k_d),

        .desired_value_i(tb_desired_value),
        .current_state_i(tb_current_state),

        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .activate_i(1'b1),

        .pid_throttle_o(tb_pid_throttle)
    );

    always #18.5 tb_clk = ~tb_clk;

    initial begin 
        $dumpfile("MotorController3/BuildFiles/tb_PIDController.vcd");
        $dumpvars(0, tb_PIDController);

        tb_k_p = 32'h00010000; // 2.0
        tb_k_i = 32'h00004000; // 0.5
        tb_k_d = 32'h00002000; // 0.05

        tb_k_p = ~tb_k_p + 1;
        tb_k_i = ~tb_k_i + 1;
        tb_k_d = tb_k_d + 1;

        tb_desired_value = 32'h00320000; // 100.0
        tb_current_state = 32'h0031e000; // 99.0

        tb_clk = 0;
        tb_nreset = 0;

        #100
        tb_nreset = 1;

        #100000000
        $finish;

    end
endmodule


        



