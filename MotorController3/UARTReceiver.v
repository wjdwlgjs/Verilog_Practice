module UARTReceiver(
    input clk_i,
    input nreset_i,

    input rx_i,

    output reg [135:0] written_values_o,
    output reg finished_o
    ); 

    reg enable;
    reg last_byte_16;
    reg [15:0] clk_counter;
    reg [3:0] bit_counter;
    reg [4:0] byte_counter;
    reg [135:0] temp_shift_reg;
    // reg sample;
    localparam [15:0] init_sample_period = 16'd4210;
    localparam [15:0] general_sample_period = 16'd2812;

    always @(posedge clk_i) begin
        if (~nreset_i) begin
            enable <= 0;
            clk_counter <= 16'b0;
            temp_shift_reg <= 136'b0;
            // sample <= 0;
        end
        else if (~enable) begin
            if (rx_i) begin
                enable <= 0;
                clk_counter <= 16'b0;
                temp_shift_reg <= temp_shift_reg;
                // sample <= 0;
            end
            else if (clk_counter == 16'd7) begin
                enable <= 1;
                clk_counter <= 16'b0;
                temp_shift_reg <= temp_shift_reg;
                // sample <= 0;
            end
            else begin
                enable <= 0;
                clk_counter <= clk_counter + 1;
                temp_shift_reg <= temp_shift_reg;
                // sample <= 0;
            end // debouncing the start bit
        end
        else begin
            if (bit_counter == 4'b0) begin
                if (clk_counter == init_sample_period) begin
                    enable <= 1;
                    clk_counter <= 16'b0;
                    temp_shift_reg <= {rx_i, temp_shift_reg[135:1]};
                    // sample <= 1;
                end
                else begin
                    enable <= 1;
                    clk_counter <= clk_counter + 1;
                    temp_shift_reg <= temp_shift_reg;
                    // sample <= 0;
                end
            end
            
            else if (bit_counter == 4'd8) begin
                if (clk_counter == general_sample_period) begin
                    enable <= 0;
                    clk_counter <= 16'b0;
                    temp_shift_reg <= temp_shift_reg;
                    // sample <= 1;
                end
                else begin
                    enable <= 1;
                    clk_counter <= clk_counter + 1;
                    temp_shift_reg <= temp_shift_reg;
                    // sample <= 0;
                end
            end

            else begin
                if (clk_counter == general_sample_period) begin
                    enable <= 1;
                    clk_counter <= 16'b0;
                    temp_shift_reg <= {rx_i, temp_shift_reg[135:1]};
                    // sample <= 1;
                end
                else begin
                    enable <= 1;
                    clk_counter <= clk_counter + 1;
                    temp_shift_reg <= temp_shift_reg;
                    // sample <= 0;
                end
            end
            
        end 
    end

    always @(posedge clk_i) begin
        if (~nreset_i) begin
            bit_counter <= 4'b0;
            byte_counter <= 5'b0;
        end
        else if (~enable) begin
            bit_counter <= 4'b0;
            byte_counter <= byte_counter;
        end
        else begin
            if (bit_counter == 4'd0) begin
                if (clk_counter == init_sample_period) begin
                    bit_counter <= bit_counter + 1;
                    byte_counter <= byte_counter;
                end
                else begin 
                    bit_counter <= bit_counter;
                    byte_counter <= byte_counter;
                end
            end
            else if (bit_counter == 4'd8) begin
                if (clk_counter == general_sample_period) begin
                    if (byte_counter == 5'd16) begin
                        bit_counter <= 3'd0;
                        byte_counter <= 5'd0;
                    end
                    else begin
                        bit_counter <= 3'd0;
                        byte_counter <= byte_counter + 1;
                    end
                end

                else begin
                    bit_counter <= bit_counter;
                    byte_counter <= byte_counter;
                end
            end
            else begin
                if (clk_counter == general_sample_period) begin
                    bit_counter <= bit_counter + 1;
                    byte_counter <= byte_counter;
                end
                else begin
                    bit_counter <= bit_counter;
                    byte_counter <= byte_counter;
                end
            end
        end
    end

    always @(posedge clk_i) begin
        if (~nreset_i) begin
            written_values_o <= 40'b0;
        end
        else if ((byte_counter == 5'b0) & ~enable) begin
            written_values_o <= temp_shift_reg;
        end
        else begin
            written_values_o <= written_values_o;
        end
    end

    always @(posedge clk_i) begin
        if (~nreset_i) last_byte_16 <= 0;
        else last_byte_16 <= byte_counter == 5'd16;
    end

    always @(*) finished_o = last_byte_16 & (byte_counter == 5'b0);


endmodule