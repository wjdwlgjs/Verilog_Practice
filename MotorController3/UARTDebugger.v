module UARTDebugger(
    input clk_i,
    input nreset_i,

    input [135:0] written_values_i,
    input [31:0] sensor_data_i,
    input initiate_i,

    output reg tx_o
    );

    reg [167:0] temp_shift_reg;
    reg [16:0] clk_counter;

    reg [3:0] bit_counter;
    reg [5:0] byte_counter;

    // localparam [16:0] init_sample_period = 16'd4210;
    localparam [16:0] general_sample_period = 16'd2811;

    always @(posedge clk_i) begin
        if (~nreset_i) begin
            temp_shift_reg <= 168'b0;
            clk_counter <= 16'b0;
            bit_counter <= 4'b0;
            byte_counter <= 5'b0;
        end
        else if (byte_counter != 5'b0) begin // byte counter also acts like enable
            if (clk_counter == general_sample_period) begin
                if (bit_counter == 4'd9) begin
                    if (byte_counter == 5'd21) begin
                        temp_shift_reg <= temp_shift_reg;
                        clk_counter <= 16'b0;
                        bit_counter <= 4'b0;
                        byte_counter <= 5'b0; // setting byte counter to 0 will make us 'exit the loop'
                    end
                    else begin
                        temp_shift_reg <= temp_shift_reg;
                        clk_counter <= 16'b0;
                        bit_counter <= 4'b0;
                        byte_counter <= byte_counter + 1;
                    end
                end
                else if (bit_counter == 4'b0) begin
                    temp_shift_reg <= temp_shift_reg;
                    clk_counter <= 16'b0;
                    bit_counter <= bit_counter + 1;
                    byte_counter <= byte_counter;
                end
                else begin
                    temp_shift_reg <= {temp_shift_reg[0], temp_shift_reg[167:1]};
                    clk_counter <= 16'b0;
                    bit_counter <= bit_counter + 1;
                    byte_counter <= byte_counter;
                end
            end
            else begin
                temp_shift_reg <= temp_shift_reg;
                clk_counter <= clk_counter + 1;
                bit_counter <= bit_counter;
                byte_counter <= byte_counter;
            end
        end
        else if (initiate_i) begin
            temp_shift_reg <= {sensor_data_i, written_values_i};
            clk_counter <= 16'b0;
            bit_counter <= 4'b0;
            byte_counter <= 5'd1;
        end
        else begin
            temp_shift_reg <= temp_shift_reg;
            clk_counter <= 16'b0;
            bit_counter <= 4'b0;
            byte_counter <= 5'b0;
        end
    end

    always @(*) begin
        if (byte_counter == 5'b0) tx_o = 1;

        else case(bit_counter) 
            4'd0: tx_o = 0;
            4'd9: tx_o = 1;
            default: tx_o = temp_shift_reg[0];
        endcase
    end
endmodule


