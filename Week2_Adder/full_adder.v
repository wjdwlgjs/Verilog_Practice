module FullAdder(
    input a_i, 
    input b_i, 
    input cin_i, 
    output sum_o, 
    output cout_o
    );

    wire first_sum, first_cout, second_cout;

    HalfAdder FirstHAdder(
        .a_i(a_i), 
        .b_i(b_i), 
        .sum_o(first_sum), 
        .cout_o(first_cout)
    );
    HalfAdder SecondHAdder(
        .a_i(first_sum), 
        .b_i(cin_i), 
        .sum_o(sum_o), 
        .cout_o(second_cout)
    );

    or(cout_o, first_cout, second_cout);
    
endmodule