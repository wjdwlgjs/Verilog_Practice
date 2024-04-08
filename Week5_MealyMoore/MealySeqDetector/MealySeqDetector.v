`timescale 1ns/1ns

module MealySeqDetector(
    input in_i,
    input clk_i,
    input nreset_i,
    output out_o
    );

    reg [1:0] cur_state;
    wire [1:0] next_state;

    // Next state comb. logic 
    assign next_state = {cur_state[0] & ~in_i, (~cur_state[1]) & in_i};
    
    // state register
    always @(posedge clk_i or negedge nreset_i) /* #2 */ begin
        if (~nreset_i) begin
            cur_state <= 2'b00;
        end
        else begin
            cur_state <= next_state;
        end
    end

    // output comb. logic
    assign out_o = cur_state[1] & in_i;

endmodule

