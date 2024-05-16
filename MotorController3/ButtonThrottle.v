module ButtonThrottle(
    input clk_i,
    input nreset_i,

    input nbutton_i,
    output reg [15:0] button_throttle_o
    );

    reg [2:0] level;
    reg [1:0] button_state;

    always @(posedge clk_i) begin
        if (~nreset_i) level <= 3'b0;
        else if (button_state == 2'b01)
        case(level)
            3'd0: level <= 3'd1;
            3'd1: level <= 3'd2;
            3'd2: level <= 3'd3;
            3'd3: level <= 3'd4;
            3'd4: level <= 3'd5;
            3'd5: level <= 3'd6;
            3'd6: level <= 3'd7;
            3'd7: level <= 3'd0;
        endcase
        else level <= level;
    end

    always @(posedge clk_i) begin
        if (~nreset_i) button_state <= 2'b0;
        else if (~nbutton_i) case(button_state) 
            2'b00: button_state <= 2'b01;
            2'b01: button_state <= 2'b10;
            2'b10: button_state <= 2'b10;
            default: button_state <= 2'b00;
        endcase
        else button_state <= 2'b00;
    end

    always @(*) case(level)
        3'd0: button_throttle_o = 16'd0;
        3'd1: button_throttle_o = 16'd3857;
        3'd2: button_throttle_o = 16'd7714;
        3'd3: button_throttle_o = 16'd11571;
        3'd4: button_throttle_o = 16'd15428;
        3'd5: button_throttle_o = 16'd19285; 
        3'd6: button_throttle_o = 16'd23142;
        3'd7: button_throttle_o = 16'd27000;
    endcase

endmodule