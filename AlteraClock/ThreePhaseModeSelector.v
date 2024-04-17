module ThreePhaseModeSelector(
    input clk_i,
    input nreset_i,
    input toggle_button_i, 
    input sync_nreset_i,

    output initial_mode_o,
    output mode1_o,
    output mode2_o,
    output mode3_o
    );

    reg [1:0] state;
    reg [1:0] next_state;

    always @(*) begin
        if (toggle_button_i)
            case(state)
                2'b01: next_state <= 2'b10;
                2'b10: next_state <= 2'b11;
                2'b11: next_state <= 2'b01;
                default: next_state <= 2'b01;
            endcase
        else if (state == 2'b00) next_state <= 2'b01;
        else next_state <= state;
    end

    always @(posedge clk_i or negedge nreset_i) begin
        if (~nreset_i) state <= 2'b00;
        else if (~sync_nreset_i) state <= 2'b00;
        else state <= next_state;
    end

    assign initial_mode_o = (state == 2'b00);
    assign mode1_o = (state == 2'b01);
    assign mode2_o = (state == 2'b10);
    assign mode3_o = (state == 2'b11);

endmodule 
        