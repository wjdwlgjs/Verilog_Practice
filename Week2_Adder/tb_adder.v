`timescale 1ns/1ns

module tb_adder();
    
    /* 
    // Half Adder Test
    reg tb_a;
    reg tb_b;
    wire tb_sum;
    wire tb_cout;

    HalfAdder hadder(
        .a_i(tb_a), 
        .b_i(tb_b), 
        .sum_o(tb_sum), 
        .cout_o(tb_cout)
    );

    initial begin
        $dumpfile("tb_adder.vcd");
        $dumpvars(0, tb_adder);
        $monitor("time: %0d, tb_a: %b, tb_b: %b, tb_sum: %b, tb_cout: %b", $time, tb_a, tb_b, tb_sum, tb_cout);

        tb_a = 0;
        tb_b = 0;

        #20
        tb_a = 0;
        tb_b = 1;

        #20
        tb_a = 1;
        tb_b = 0;

        #20
        tb_a = 1;
        tb_b = 1;

        #20
        tb_a = 0;
        tb_b = 0;

    end */

    /* 
    // Full Adder Test
    reg tb_a;
    reg tb_b;
    reg tb_cin;
    wire tb_sum;
    wire tb_cout;

    FullAdder FAdder(
        .a_i(tb_a), 
        .b_i(tb_b), 
        .cin_i(tb_cin), 
        .sum_o(tb_sum), 
        .cout_o(tb_cout)
    );

    initial begin
        $dumpfile("tb_adder.vcd");
        $dumpvars(0, tb_adder);
        $monitor("time: %0d, tb_a: %b, tb_b: %b, tb_cin: %b, tb_sum: %b, tb_cout: %b", $time, tb_a, tb_b, tb_cin, tb_sum, tb_cout);

        tb_cin = 0;
        tb_a = 0;
        tb_b = 0;

        #20
        tb_cin = 0;
        tb_a = 0;
        tb_b = 1;

        #20
        tb_cin = 0;
        tb_a = 1;
        tb_b = 0;

        #20
        tb_cin = 0;
        tb_a = 1;
        tb_b = 1;

        #20
        tb_cin = 1;
        tb_a = 0;
        tb_b = 0;

        #20
        tb_cin = 1;
        tb_a = 0;
        tb_b = 1;

        #20
        tb_cin = 1;
        tb_a = 1;
        tb_b = 0;

        #20
        tb_cin = 1;
        tb_a = 1;
        tb_b = 1;

        #20
        tb_cin = 0;
        tb_a = 0;
        tb_b = 0;
    end */


    // Four Bit Adder Test
    reg [3:0] tb_a;
    reg [3:0] tb_b;
    reg tb_cin;
    wire [4:0] tb_sum;

    FourBitAdder FAdder4Bit(
        .a_i(tb_a),
        .b_i(tb_b),
        .cin_i(tb_cin),
        .sum_o(tb_sum)
    );

    initial begin
        $dumpfile("tb_adder.vcd");
        $dumpvars(0, tb_adder);
        $monitor("time: %0d, tb_a: %d, tb_b: %d, tb_cin: %b, tb_sum: %d", $time, tb_a, tb_b, tb_cin, tb_sum);

        tb_cin = 0;
        tb_a = 4'b0000;
        tb_b = 4'd0;

        #20
        tb_a = 4'd1;
        tb_b = 4'd13;

        #20
        tb_a = 4'd15;
        tb_b = 4'd12;

        #20
        tb_a = 4'd5;
        tb_b = 4'd2;

        #20
        tb_a = 4'd1;
        tb_b = 4'd0;

        #20
        tb_a = 4'd14;
        tb_b = 4'd4;

        #20
        tb_a = 4'd0;
        tb_b = 4'd6;

        #20
        tb_a = 4'd0;
        tb_b = 4'd0;
    end
    
endmodule