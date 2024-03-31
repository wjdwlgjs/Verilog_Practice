`timescale 1ns/1ns

module tb_Dlatch();
    reg tb_D;
    reg tb_E;
    wire tb_Q;

    CuatomDLatch Dlatch(
        .D(tb_D),
        .E(tb_E),
        .Q(tb_Q)
    );

    initial begin

        $dumpfile("tb_DLatch.vcd");
        $dumpvars(0,tb_DLatch);
        $monitor("time: %0d, tb_D: %b, tb_E: %b, tb_Q: %b", $time, tb_D, tb_E, tb_Q);

        tb_D = 1'b0;
        tb_E = 1'b1; //Q=Q

        #20
        tb_D = 1'b0;
        tb_E = 1'b1; //Q=0

        #20
        tb_D = 1'b1;
        tb_E = 1'b0; //Q=0

        #20
        tb_D = 1'b1;
        tb_E = 1'b1; //Q=1

        #20
        tb_D = 1'b1;
        tb_E = 1'b0; //Q=1

        #20
        tb_D = 1'b0;
        tb_E = 1'b1; //Q=0

        #20
        tb_D = 1'b0;
        tb_E = 1'b0; //Q=0
end
endmodule