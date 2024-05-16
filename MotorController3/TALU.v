/* module TALU( // TALU stands for Terrible Arithmetic Logic Unit
    // input/output format:
    // |1|       16       |       15      |
    // |S|IIIIIIIIIIIIIIII|FFFFFFFFFFFFFFF|
    input [31:0] first_operand_i,
    input [31:0] second_operand_i,
    input [1:0] opcode_i, // 00 for add, 01 for sub, 10 for multiply, 11 for division (not implemented)

    output reg [31:0] result_o
    );

    wire [31:0] first_operand_minus;
    wire [31:0] second_operand_minus;
    wire [31:0] adder_result;
    wire [31:0] mult_result;

    assign first_operand_minus = ~first_operand_i + 1;
    assign second_operand_minus = ~second_operand_i + 1;

    TAdder AdderInst(
        .first_operand_i(first_operand_i),
        .second_operand_i(second_operand_i),
        .second_operand_minus_i(second_operand_minus),
        .sub_i(opcode_i[0]),

        .sum_o(adder_result)
    );

    TMultiplier MultInst(
        .first_operand_i(first_operand_i),
        .second_operand_i(second_operand_i),
        .first_operand_minus_i(first_operand_minus),
        .second_operand_minus_i(second_operand_minus),
        
        .product_o(mult_result)
    );

    always @(*) begin
        if (opcode_i[1]) result_o = adder_result;
        else result_o = mult_result;
    end

endmodule */

module TAdder( // TAdder, TMultiplier stands for Terrible Adder, Terrible Multiplier
    input [31:0] first_operand_i,
    input [31:0] second_operand_i,
    input subtract_i,

    output reg [31:0] sum_o
    );

    localparam [31:0] positive_limit = 32'h7fffffff;
    localparam [31:0] negative_limit = 32'h80000000;

    reg [31:0] real_second_operand;
    always @(*) begin
        if (subtract_i) real_second_operand = ~second_operand_i + 1;
        else real_second_operand = second_operand_i;
    end

    assign one_is_neg = first_operand_i[31] ^ real_second_operand[31]; 

    wire [31:0] temp_sum;

    assign temp_sum = first_operand_i + real_second_operand;

    always @(*) begin
        if (one_is_neg) sum_o = temp_sum; // two operands signs are different. overflow is impossible
        else if (temp_sum[31] != first_operand_i[31]) begin // two operands signs are the same, but output sign is different. overflow has happened
            if (real_second_operand[31]) sum_o = negative_limit; // they are negative
            else sum_o = positive_limit;
        end
        else sum_o = temp_sum; // two operands signs are the same, but overflow didn't happen
    end

endmodule

module TMultiplier(
    input [31:0] first_operand_i,
    input [31:0] second_operand_i,

    output reg [31:0] product_o
    );

    localparam [31:0] positive_limit = 32'h7fffffff;
    localparam [31:0] negative_limit = 32'h80000000;

    wire [63:0] temp_product;
    wire [31:0] first_operand_minus;
    wire [31:0] second_operand_minus;
    reg [31:0] real_first_operand;
    reg [31:0] real_second_operand;

    wire one_is_neg;

    assign one_is_neg = first_operand_i[31] ^ second_operand_i[31];
    assign first_operand_minus = ~first_operand_i + 1;
    assign second_operand_minus = ~second_operand_i + 1;

    always @(*) begin
        if (first_operand_i[31]) real_first_operand = first_operand_minus;
        else real_first_operand = first_operand_i;
    end
    always @(*) begin
        if (second_operand_i[31]) real_second_operand = second_operand_minus;
        else real_second_operand = second_operand_i;
    end
    assign temp_product = real_first_operand * real_second_operand;

    always @(*) begin
        if (temp_product[63:46] == 18'b0) begin // no overflow
            if (one_is_neg) product_o = ~temp_product[46:15] + 1;
            else product_o = temp_product[46:15];
        end
        else begin // overflow has happened
            if (one_is_neg) product_o = negative_limit;
            else product_o = positive_limit;
        end
    end


endmodule

