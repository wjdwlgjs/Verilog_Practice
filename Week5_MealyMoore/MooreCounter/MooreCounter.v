`timescale 1ns/1ns

module MooreCounter(
    input in_i,
    input clk_i,
    input nreset_i,
    output [1:0] count_o
    );

    wire [1:0] next_state;
    reg [1:0] cur_state;

    // Next state comb. logic 
    assign next_state = {(cur_state[1] & ~in_i) | (cur_state[0] & in_i), (cur_state[0] & ~in_i) | (~cur_state[0] & in_i)};

    // state register
    always @(posedge clk_i or negedge nreset_i) #2 begin
        if (~nreset_i) cur_state <= 2'b00;
        else cur_state <= next_state;
    end 

    // output comb. logic: count = cur_state;
    assign count_o = cur_state;

endmodule

