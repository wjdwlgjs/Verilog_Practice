`include "MotorController3/TALU.v"
`timescale 1ns/1ns

module tb_TALU();

    reg [31:0] tb_first_operand;
    reg [31:0] tb_second_operand;

    reg tb_subtract;

    wire [31:0] tb_sum;
    wire [31:0] tb_product;

    reg [31:0] first_operand_abs;
    reg [31:0] second_operand_abs;
    reg [31:0] product_abs;
    reg [31:0] sum_abs;
    wire [15:0] first_operand_abs_int;
    wire [15:0] first_operand_abs_frac;
    wire [15:0] second_operand_abs_int;
    wire [15:0] second_operand_abs_frac;
    wire [15:0] sum_abs_int;
    wire [15:0] sum_abs_frac;
    wire [15:0] product_abs_int;
    wire [15:0] product_abs_frac;

    always @(*) begin
        if (tb_first_operand[31]) first_operand_abs = ~tb_first_operand + 1;
        else first_operand_abs = tb_first_operand;

        if (tb_second_operand[31]) second_operand_abs = ~tb_second_operand + 1;
        else second_operand_abs = tb_second_operand;

        if (tb_sum[31]) sum_abs = ~tb_sum + 1;
        else sum_abs = tb_sum;

        if (tb_product[31]) product_abs = ~tb_product + 1;
        else product_abs = tb_product;
    end

    assign first_operand_abs_int = first_operand_abs[30:15];
    assign first_operand_abs_frac = {first_operand_abs[14:0], 1'b0};

    assign second_operand_abs_int = second_operand_abs[30:15];
    assign second_operand_abs_frac = {second_operand_abs[14:0], 1'b0};
    
    assign sum_abs_int = sum_abs[30:15];
    assign sum_abs_frac = {sum_abs[14:0], 1'b0};

    assign product_abs_int = product_abs[30:15];
    assign product_abs_frac = {product_abs[14:0], 1'b0};
    
    TAdder TestAdder(
        .first_operand_i(tb_first_operand),
        .second_operand_i(tb_second_operand),
        .subtract_i(tb_subtract),
        .sum_o(tb_sum)
    );

    TMultiplier TestMult(
        .first_operand_i(tb_first_operand),
        .second_operand_i(tb_second_operand),
        .product_o(tb_product)
    );

    initial begin
        $dumpfile("MotorController3/BuildFiles/tb_TALU.vcd");
        $dumpvars(0, tb_TALU);
        tb_first_operand = 32'b0;
        tb_second_operand = 32'b0;

        tb_subtract = 0;
        
        for (integer i = 0; i < 100; i = i + 1) begin
            #10;
            
            tb_first_operand = 32'h007fffff & $random;
            tb_second_operand = 32'h007fffff & $random;

            tb_subtract = $random;
        end

        #10
        $finish;
    end

endmodule


