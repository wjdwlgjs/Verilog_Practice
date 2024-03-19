module FourBitAdder(
    input [3:0] a_i,
    input [3:0] b_i,
    input cin_i, 
    output [4:0] sum_o
    );
    
    wire carry_1, carry_2, carry_3;

    FullAdder FAdder0(
        .a_i(a_i[0]), 
        .b_i(b_i[0]), 
        .cin_i(cin_i), 
        .sum_o(sum_o[0]),
        .cout_o(carry_1)
    );
    FullAdder FAdder1(
        .a_i(a_i[1]), 
        .b_i(b_i[1]), 
        .cin_i(carry_1),
        .sum_o(sum_o[1]), 
        .cout_o(carry_2)
    );
    FullAdder FAdder2(
        .a_i(a_i[2]), 
        .b_i(b_i[2]), 
        .cin_i(carry_2), 
        .sum_o(sum_o[2]), 
        .cout_o(carry_3)
    );
    FullAdder FAdder3(
        .a_i(a_i[3]), 
        .b_i(b_i[3]), 
        .cin_i(carry_3),
        .sum_o(sum_o[3]), 
        .cout_o(sum_o[4])
    );

endmodule 
