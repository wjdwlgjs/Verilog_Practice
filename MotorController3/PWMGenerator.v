// Since the use of the dron BLDC motor was something we decided on our own, and the PWM signal it needs is different from what conventional DC motors typically need, 
// We decided to treat it as one of our "additional features", and make our design capable of handling both the cheap motor and the BLDC. Not much more has to be implemented to achive this.

// This pulse generator is capable of controlling both conventional (analog) DC motor drivers, and digital BLDC or servo motor drivers.
// the latter considers '1ms high + 19ms low' as a 0% throttle, and '2ms high + 18ms low' as a 100%.
// Arduino's Servo.write(0~180) library function does this.

// the former is implemented to resemble arduino's analogWrite(0~255) function on pins 5, 6. 
// 0% throttle is '0ms high + 1ms low', and 100% throttle is '1ms high + 0ms low'

module PWMGenerator(
    input clk_i,
    input nreset_i,
    
    input [15:0] throttle_i, // a 16bit unsigned integer that indicates the amount of clk cycles to output a high signal, out of 1ms. Assuming we use the 27mhz clock, it should be between 0~26999. something higher will just be 100% throttle
    input is_digital_i,
    
    output reg pulse_o
    );

    /* localparam [15:0] twenty_ms_in_microsec = 16'd19999;
    localparam [15:0] one_ms_in_microsec = 16'd999;
    localparam [7:0] one_microsec_in_clk_cycles = 7'd26; */

    localparam [31:0] twenty_ms = 32'd540000;
    localparam [31:0] one_ms = 32'd26999;
    
    reg [31:0] clk_counter;
    reg [31:0] threshold;

    always @(*) begin
        if (is_digital_i) threshold = {16'b0, throttle_i} + one_ms;
        else threshold = {16'b0, throttle_i};
    end

    always @(posedge clk_i) begin
        if (~nreset_i) clk_counter <= 32'b0;
        else begin
            if (clk_counter == twenty_ms) clk_counter <= 32'b0;
            else if (clk_counter == one_ms & ~is_digital_i) clk_counter <= 32'b0;
            else clk_counter <= clk_counter + 1;
        end
    end

    always @(posedge clk_i) begin
        if (~nreset_i) pulse_o <= 0;
        else if (clk_counter == threshold) pulse_o <= 0;
        else if (clk_counter == 32'b0) pulse_o <= 1;
        else pulse_o <= pulse_o;
    end

endmodule