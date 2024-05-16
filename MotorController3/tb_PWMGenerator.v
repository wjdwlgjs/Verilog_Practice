`include "MotorController3/PWMGenerator.v"
`timescale 1ns/1ns

module tb_PWMGenerator();
    reg tb_clk;
    reg tb_nreset;
    
    reg [14:0] tb_throttle; 
    reg tb_is_digital;
    
    wire tb_pulse;

    // always #18.5 tb_clk = ~tb_clk;
    always #1 tb_clk = ~tb_clk;

    PWMGenerator TestGenerator(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        
        .throttle_i(tb_throttle), 
        .is_digital_i(tb_is_digital),
        
        .pulse_o(tb_pulse)
    );

    initial begin
        $dumpfile("MotorController3/BuildFiles/tb_PWMGenerator.vcd");
        $dumpvars(0, tb_PWMGenerator);

        tb_clk = 0;
        tb_nreset = 0;
        
        tb_throttle = 0; 
        tb_is_digital = 0;

        #100
        tb_nreset = 1;

        /* for (integer i = 0; i < 128; i = i + 1) begin
            tb_throttle[15:8] = i;
            tb_throttle[7:0] = $random;
            #100000;
        end */

        /* tb_is_digital = 1;
        for (integer j = 0; j < 128; j = j + 1) begin
            tb_throttle[15:8] = j;
            tb_throttle[7:0] = $random;
            #100000;
        end
        $finish; */

        tb_is_digital = 1;
        tb_throttle[14:8] = 7'd0;
        tb_throttle[7:0] = 8'h00;

        #10000000
        $finish;

    end
endmodule


        