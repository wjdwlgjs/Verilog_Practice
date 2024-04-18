// `include "AlteraClock/FFJK.v"

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

endmodule


module PulseGeneratorSmall(
    input clk_i,
    input nreset_i,
    input [7:0] period_i, // 00110010
    
    output reg pulse_o
    );

    wire [7:0] count;
    wire limit_reached;
    assign limit_reached = (count == period_i);

    wire [7:0] toggle;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: JKFFArrayForPulseSmall
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

endmodule