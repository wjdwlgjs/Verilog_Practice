module CustomDFF(
    input d_i,
    input clk_i,
    input nreset_i,
    output reg q_o
    );

    always @(posedge clk_i or negedge nreset_i) begin
        if (nreset_i == 1'b0)
            q_o = 1'b0;
        else
            q_o = d_i;
    end
endmodule