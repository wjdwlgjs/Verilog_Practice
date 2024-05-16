// `include "MotorController3/TALU.v"

module UltraSoundInterface(
    input clk_i,
    input nreset_i,

    input echo_i,

    output reg trig_o,
    output reg [31:0] dist_o
    );

    localparam [31:0] mach_one_cm_per_us = 32'h0000045a;
    
    wire [31:0] mult_output;

    reg [4:0] clk_count;
    reg [19:0] us_count;
    reg [4:0] echo_clk_count;
    reg [19:0] echo_us_count;

    always @(posedge clk_i) begin
        if (~nreset_i) begin
            clk_count <= 5'b0;
            us_count <= 20'b0;
        end
        else if (clk_count == 5'd26) begin // reset us count and restart the whole process every 80 ms
            if (us_count == 20'd79999) begin
                clk_count <= 5'b0;
                us_count <= 20'b0;
            end
            else begin
                clk_count <= 5'b0;
                us_count <= us_count + 1;
            end
        end
        else begin
            clk_count <= clk_count + 1;
            us_count <= us_count;
        end
    end

    always @(posedge clk_i) begin
        if (~nreset_i) begin
            echo_clk_count <= 5'b0;
            echo_us_count <= 20'b0;
        end 
        else if (us_count == 20'b0) begin
            echo_clk_count <= 5'b0;
            echo_us_count <= 20'b0;
        end
        else if (echo_i) begin
            if (echo_clk_count == 5'd26) begin
                echo_clk_count <= 5'b0;
                echo_us_count <= echo_us_count + 1;
            end
            else begin
                echo_clk_count <= echo_clk_count + 1;
                echo_us_count <= echo_us_count;
            end
        end
        else begin
            echo_clk_count <= echo_clk_count;
            echo_us_count <= echo_us_count;
        end
    end

    TMultiplier SonarMultInst(
        .first_operand_i({1'b0, echo_us_count[15:0], 15'b0}),
        .second_operand_i(mach_one_cm_per_us),
        .product_o(mult_output)
    );

    always @(posedge clk_i) begin
        if (~nreset_i) dist_o <= 32'b0;
        else if (us_count == 20'd79999) dist_o <= mult_output;
        else dist_o <= dist_o;
    end

    always @(posedge clk_i) begin
        if (~nreset_i) trig_o <= 0;
        else if (us_count == 20'd1) trig_o <= 1;
        else if (us_count == 20'd12) trig_o <= 0;
        else trig_o <= trig_o;
    end

        

endmodule 

