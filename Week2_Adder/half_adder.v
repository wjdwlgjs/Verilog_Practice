module HalfAdder(
    input a_i, 
    input b_i, 
    output sum_o, 
    output cout_o
    );
    
    xor(sum_o, a_i, b_i);
    and(cout_o, a_i, b_i);

endmodule
