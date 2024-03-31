module CustomDLatch(
    input D,
    input E,
    output reg Q
);
    always @(D or E)
    begin
    if(E == 1) Q = D;
    else Q = Q;
    end
endmodule