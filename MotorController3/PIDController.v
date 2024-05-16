// `include "MotorController3/TALU.v"

module PIDController(
    input [31:0] k_p_i,
    input [31:0] k_i_i,
    input [31:0] k_d_i,

    input [31:0] desired_value_i,
    input [31:0] current_state_i,

    input clk_i,
    input nreset_i,
    input activate_i,

    output [15:0] pid_throttle_o
    );

    // The process is like:
    
    // first clk cycle:
    // $1 <= desired_value - current_state (current error)

    // second clk cycle:
    // $1 <= $prev - $1 (error difference)
    // $prev <= 1 * $1 (current error)
    
    // third clk cycle:
    // $2 <= $(dt^-1) * $1 (de/dt)

    // fourth clk cycle:
    // $1 <= $prev * $dt (edt)

    // fifth clk cycle:
    // $2 <= $2 * k_d (control value based on d)
    // $int <= $int + $1 (new integral)

    // sixth clk cycle:
    // $1 <= k_i * $int (control value based on i)

    // seventh clk cycle:
    // $2 <= $2 + $1 (sum of d_control and i_control)
    // $1 <= $prev * k_p (control value based on p)

    // eighth clk cycle:
    // $1 <= $2 + $1 (sum of p, i, d control values)

    // nineth clk cycle:
    // $throttle <= $throttle + $1

    localparam [31:0] one = 32'h00008000;
    localparam [31:0] zero = 32'b0;
    /* 0.000001010001111010111000010100011110101110000101000111101011100001
    32'd0000051e */
    localparam [31:0] twenty_ms_in_sec = 32'h00000a3d; // 0.08
    localparam [31:0] dt_inverse = 32'h00064000; // 12.5

    reg [31:0] register_int; // stores the integral of errors
    reg [31:0] register_prev; // stores the previous error
    reg [31:0] register_1;
    reg [31:0] register_2;
    reg [31:0] register_throttle;

    reg [31:0] adder_first_operand;
    reg [31:0] adder_second_operand;
    reg subtract;
    reg [31:0] mult_first_operand;
    reg [31:0] mult_second_operand;

    wire [31:0] adder_result;
    wire [31:0] mult_result;

    reg [31:0] clk_counter;

    TAdder AdderInst(
        .first_operand_i(adder_first_operand),
        .second_operand_i(adder_second_operand),
        .subtract_i(subtract),

        .sum_o(adder_result)
    );

    TMultiplier MultInst(
        .first_operand_i(mult_first_operand),
        .second_operand_i(mult_second_operand),
        .product_o(mult_result)
    );

    always @(*) begin
        case(clk_counter)
            32'd1: begin 
                // first clk cycle:
                // $1 <= desired_value - current_state (current error)
                adder_first_operand = desired_value_i;
                adder_second_operand = current_state_i;
                subtract = 1;
                mult_first_operand = 32'b0;
                mult_second_operand = 32'b0;
            end
            32'd2: begin
                // second clk cycle:
                // $1 <= $prev - $1 (error difference)
                // $prev <= 1 * $1 (current error)
                adder_first_operand = register_prev;
                adder_second_operand = register_1;
                subtract = 1;
                mult_first_operand = one;
                mult_second_operand = register_1;
            end
            32'd3: begin
                // third clk cycle:
                // $2 <= $(dt^-1) * $1 (de/dt)
                adder_first_operand = register_prev;
                adder_second_operand = register_1;
                subtract = 1;
                mult_first_operand = dt_inverse;
                mult_second_operand = register_1;
            end
            32'd4: begin
                // fourth clk cycle:
                // $1 <= $prev * $dt (edt)
                adder_first_operand = register_prev;
                adder_second_operand = register_1;
                subtract = 0;
                mult_first_operand = register_prev;
                mult_second_operand = twenty_ms_in_sec;
            end
            32'd5: begin
                // fifth clk cycle:
                // $int <= $int + $1 (new integral)
                // $2 <= $2 * k_d (control value based on d)
                adder_first_operand = register_int;
                adder_second_operand = register_1;
                subtract = 0;
                mult_first_operand = register_2;
                mult_second_operand = k_d_i;
            end
            32'd6: begin
                // sixth clk cycle:
                // $1 <= k_i * $int (control value based on i)
                adder_first_operand = register_int;
                adder_second_operand = register_1;
                subtract = 0;
                mult_first_operand = k_i_i;
                mult_second_operand = register_int;
            end
            32'd7: begin
                // seventh clk cycle:
                // $2 <= $2 + $1 (sum of d_control and i_control)
                // $1 <= $prev * k_p (control value based on p)
                adder_first_operand = register_2;
                adder_second_operand = register_1;
                subtract = 0;
                mult_first_operand = register_prev;
                mult_second_operand = k_p_i;
            end
            32'd8: begin
                // eighth clk cycle:
                // $1 <= $2 + $1 (sum of p, i, d control values)
                adder_first_operand = register_2;
                adder_second_operand = register_1;
                subtract = 0;
                mult_first_operand = register_prev;
                mult_second_operand = k_p_i;
            end
            32'd9: begin
                // nineth clk cycle:
                // $throttle <= $throttle + $1
                adder_first_operand = register_throttle;
                adder_second_operand = register_1;
                subtract = 0;
                mult_first_operand = register_prev;
                mult_second_operand = k_p_i;
            end
            default: begin
                adder_first_operand = register_throttle;
                adder_second_operand = register_1;
                subtract = 0;
                mult_first_operand = register_prev;
                mult_second_operand = k_p_i;
            end
        endcase
    end

    always @(posedge clk_i) begin
        if (~nreset_i) begin
            register_int <= zero; // stores the integral of errors
            register_prev <= zero; // stores the previous error
            register_1 <= zero;
            register_2 <= zero;
        end
        else case(clk_counter)
            32'd1: begin
                // first clk cycle:
                // $1 <= desired_value - current_state (current error)
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= adder_result;
                register_2 <= register_2;
            end
            32'd2: begin
                // second clk cycle:
                // $1 <= $prev - $1 (error difference)
                // $prev <= 1 * $1 (current error)
                register_int <= register_int;
                register_prev <= mult_result;
                register_1 <= adder_result;
                register_2 <= register_2;
            end
            32'd3: begin
                // third clk cycle:
                // $2 <= $(dt^-1) * $1 (de/dt)
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= register_1;
                register_2 <= mult_result;
            end
            32'd4: begin
                // fourth clk cycle:
                // $1 <= $prev * $dt (edt)
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= mult_result;
                register_2 <= register_2;
            end
            32'd5: begin
                // fifth clk cycle:
                // $int <= $int + $1 (new integral)
                // $2 <= $2 * k_d (control value based on d)
                register_int <= adder_result;
                register_prev <= register_prev;
                register_1 <= register_1;
                register_2 <= mult_result;
            end
            32'd6: begin
                // sixth clk cycle:
                // $1 <= k_i * $int (control value based on i)
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= mult_result;
                register_2 <= register_2;
            end
            32'd7: begin
                // seventh clk cycle:
                // $2 <= $2 + $1 (sum of d_control and i_control)
                // $1 <= $prev * k_p (control value based on p)
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= mult_result;
                register_2 <= adder_result;
            end
            32'd8: begin
                // eighth clk cycle:
                // $1 <= $2 + $1 (sum of p, i, d control values)
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= adder_result;
                register_2 <= register_2;
            end
            32'd9: begin
                // nineth clk cycle:
                // $throttle <= $throttle + $1
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= register_1;
                register_2 <= register_2;
            end
            default: begin
                register_int <= register_int;
                register_prev <= register_prev;
                register_1 <= register_1;
                register_2 <= register_2;
            end
        endcase
    end

    always @(posedge clk_i) begin
        if (~nreset_i) clk_counter <= zero;
        else if (~activate_i) clk_counter <= zero;
        else if (clk_counter == 32'd2160000) clk_counter <= zero;
        else clk_counter <= clk_counter + 1;
    end

    always @(posedge clk_i) begin
        if (~nreset_i) register_throttle <= 32'b0;
        else if (clk_counter == 32'd10) begin
            if (adder_result[31]) register_throttle <= 32'b0; // minus throttle can't be a thing
            else register_throttle <= adder_result;
        end
        else register_throttle <= register_throttle;
    end

    assign pid_throttle_o = register_throttle[31:16];

endmodule
