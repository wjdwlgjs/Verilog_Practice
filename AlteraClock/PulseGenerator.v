`include "AlteraClock/FFJK.v"

module PulseGenerator(
    input clk_i,
    input nreset_i,
    input [31:0] period_i, // 111101000010010000
    
    output reg pulse_o
    );

    wire [31:0] count;
    wire limit_reached;
    assign limit_reached = (count == period_i);

    wire [31:0] toggle;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: JKFFArrayForPulse
            assign toggle[i] = (i == 0? 1'b1: toggle[i-1] & count[i-1]);
            FFJK JKFFInstForPulse(
                .j_i(~limit_reached & toggle[i]),
                .k_i(limit_reached | toggle[i]),
                .nreset_i(nreset_i),
                .enable_i(clk_i),
                .q_o(count[i])
            );
        end
    endgenerate

    always @(negedge limit_reached or negedge nreset_i) begin
        if (~nreset_i) pulse_o <= 0;
        else 
            pulse_o <= ~pulse_o;
    end

endmodule;


module BlinkingSignalGenerator(
    input clk_i,
    input nreset_i,
    input [3:0] period_i, // 0101
    
    output pulse_o
    );

    reg [3:0] count;

    always @(posedge clk_i or negedge nreset_i) begin
        if (~nreset_i) count <= 4'b0;
        else if (count == period_i) count <= 4'b0;
        else count <= count + 1;
    end
endmodule
