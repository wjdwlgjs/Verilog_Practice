/* `include "MotorController3/UARTReceiver.v"
`include "MotorController3/PIDController.v"
`include "MotorController3/TALU.v"
`include "MotorController3/UARTDebugger.v"
`include "MotorController3/UltraSoundInterface.v"
`include "MotorController3/PWMGenerator.v" */

module MotorController3(
    input clk_i,
    input nreset_i,

    input nbutton_i,
    
    input rx_i,
    output tx_o,

    input echo_i,
    output trig_o,

    output pulse_o,

    output [17:0] leds_o,
    output [3:0] settings_leds_o
    );

    wire [135:0] written_values;
    wire [31:0] sensor_data;
    wire receive_finished;

    wire is_digital;
    wire [1:0] mode;
    wire debug;
    wire [31:0] desired_value;
    wire [31:0] k_p;
    wire [31:0] k_i;
    wire [31:0] k_d;

    reg [15:0] throttle;
    wire [15:0] pid_throttle;
    wire [15:0] button_throttle;

    // assign sensor_data = 32'h12345678;

    assign is_digital = written_values[0];
    assign mode = written_values[2:1];
    assign debug = written_values[3];
    assign desired_value = written_values[39:8];
    assign k_p = written_values[71:40];
    assign k_i = written_values[103:72];
    assign k_d = written_values[135:104];
    
    UARTReceiver ReceiverInst(
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .rx_i(rx_i),
        .written_values_o(written_values),
        .finished_o(receive_finished)
    );

    UARTDebugger DebuggerInst(
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .written_values_i(written_values),
        .sensor_data_i(sensor_data),
        .initiate_i(receive_finished),
        .tx_o(tx_o)
    );

    always @(*) begin
        case(mode)
            2'b00: throttle = 16'b0;
            2'b01: throttle = desired_value[15:0];
            2'b10: throttle = pid_throttle;
            2'b11: throttle = button_throttle;
        endcase
    end

    PWMGenerator PWMInst(
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .throttle_i(throttle),
        .is_digital_i(is_digital),
        .pulse_o(pulse_o)
    );

    UltraSoundInterface SonarInst(
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .echo_i(echo_i),
        .trig_o(trig_o),
        .dist_o(sensor_data)
    );

    PIDController PIDInst(
        .k_p_i(k_p),
        .k_i_i(k_i),
        .k_d_i(k_d),
        .desired_value_i(desired_value),
        .current_state_i(sensor_data),
        .clk_i(clk_i),
        .nreset_i(nreset_i),
        .activate_i(mode == 2'b10),
        .pid_throttle_o(pid_throttle)
    );

    ButtonThrottle ButtonInst(
        .clk_i(clk_i),
        .nreset_i(nreset_i),

        .nbutton_i(nbutton_i),
        .button_throttle_o(button_throttle)
    );

    assign settings_leds_o[3] = debug;
    assign settings_leds_o[2:1] = mode;
    assign settings_leds_o[0] = is_digital;

    assign leds_o[0] = throttle > 16'd0;
    assign leds_o[1] = throttle > 16'd1500;
    assign leds_o[2] = throttle > 16'd3000;
    assign leds_o[3] = throttle > 16'd4500;
    assign leds_o[4] = throttle > 16'd6000;
    assign leds_o[5] = throttle > 16'd7500;
    assign leds_o[6] = throttle > 16'd9000;
    assign leds_o[7] = throttle > 16'd10500;
    assign leds_o[8] = throttle > 16'd12000;
    assign leds_o[9] = throttle > 16'd13500;
    assign leds_o[10] = throttle > 16'd15000;
    assign leds_o[11] = throttle > 16'd16500;
    assign leds_o[12] = throttle > 16'd18000;
    assign leds_o[13] = throttle > 16'd19500;
    assign leds_o[14] = throttle > 16'd21000;
    assign leds_o[15] = throttle > 16'd22500;
    assign leds_o[16] = throttle > 16'd24000;
    assign leds_o[17] = throttle > 16'd25500;

endmodule

    