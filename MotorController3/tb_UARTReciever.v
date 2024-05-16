`include "MotorController3/UARTReceiver.v"
`timescale 1ns/1ns

/* module tb_UARTReceiver();
    
    reg tb_clk;
    reg tb_nreset;

    reg tb_send_init;

    reg tb_rx;

    wire [39:0] tb_written_values;

    reg [39:0] data_to_send;
    reg [7:0] byte_to_send;
    reg [3:0] tb_data_count;
    reg [3:0] tb_byte_count;

    always #18.5 tb_clk = ~tb_clk;

    always @(*) begin
        case(tb_data_count) 
            4'd0: data_to_send = 40'h5555555555;
            4'd1: data_to_send = 40'h1234567890;
            4'd2: data_to_send = 40'h1212121212;
            4'd3: data_to_send = 40'h1231231231;
            4'd4: data_to_send = 40'h1234123412;
            4'd5: data_to_send = 40'h1234512345;
            4'd6: data_to_send = 40'h1234561234;
            4'd7: data_to_send = 40'h1234567123;
            4'd8: data_to_send = 40'h1234567812;
            4'd9: data_to_send = 40'h1234567891;
            4'd10: data_to_send = 40'h123456789a;
            default: data_to_send = 40'b0;
        endcase
    end

    always @(*) begin
        case(tb_byte_count) 
            4'd0: byte_to_send = data_to_send[7:0];
            4'd1: byte_to_send = data_to_send[15:8];
            4'd2: byte_to_send = data_to_send[23:16];
            4'd3: byte_to_send = data_to_send[31:24];
            4'd4: byte_to_send = data_to_send[39:32];
        endcase
    end
        
    always @(posedge tb_send_init) #100 tb_send_init = 0;


    
    UARTReceiver TestReceiver(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),

        .rx_i(tb_rx),

        .written_values_o(tb_written_values)
    );

    initial begin
        $dumpfile("MotorController3/BuildFiles/tb_UARTReceiver.vcd");
        $dumpvars(0, tb_UARTReceiver);


        tb_clk = 0;
        tb_nreset = 0;

        tb_send_init = 0;

        tb_rx = 1;

        #100 
        tb_nreset = 1;


        for (integer i = 0; i < 10; i = i + 1) begin
            tb_data_count = i;
            for (integer j = 0; j < 5; j = j + 1) begin
                tb_byte_count = j;
                tb_rx = 0;
                #104168;
                tb_rx = byte_to_send[0];
                #104168;
                tb_rx = byte_to_send[1];
                #104168;
                tb_rx = byte_to_send[2];
                #104168;
                tb_rx = byte_to_send[3];
                #104168;
                tb_rx = byte_to_send[4];
                #104168;
                tb_rx = byte_to_send[5];
                #104168;
                tb_rx = byte_to_send[6];
                #104168;
                tb_rx = byte_to_send[7];
                #104168;
                tb_rx = 1;
                #104168;
            end
        end


        $finish;
    end
endmodule
 */


module tb_UARTReceiver();

    reg tb_clk;
    reg tb_nreset;

    reg tb_rx;

    wire [135:0] tb_written_values;

    UARTReceiver TestReceiver(
        .clk_i(tb_clk),
        .nreset_i(tb_nreset),
        .rx_i(tb_rx),
        .written_values_o(tb_written_values)
    );

    always #18.5 tb_clk = ~tb_clk;

    reg [135:0] data_to_send;

    initial begin
        $dumpfile("MotorController3/BuildFiles/tb_UARTReceiver.vcd");
        $dumpvars(0, tb_UARTReceiver);

        tb_clk = 0;
        tb_nreset = 0;
        tb_rx = 1;
        data_to_send = $random * $random;
        
        #100
        tb_nreset = 1;

        #100
        for (integer i = 0; i < 136; i = i + 1) begin
            tb_rx = 0;
            #104168;
            for (integer j = 0; j < 8; j = j + 1) begin
                tb_rx = data_to_send[0];
                data_to_send = {data_to_send[0], data_to_send[135:1]};
                #104168;
            end
            tb_rx = 1;
            #104168;
        end

        #100000

        $finish;
    end

endmodule


