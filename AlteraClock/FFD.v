module FFD( // negedge triggered
    input d_i,
    input enable_i,
    input nreset_i, // asynchronous low level reset
    output reg q_o
    );

    always @(negedge enable_i or negedge nreset_i) begin
        if (nreset_i == 1'b0)
            q_o <= 1'b0;
    
        else 
            q_o <= d_i;
    end
endmodule