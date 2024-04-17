module FFJK(
    input j_i,
    input k_i,
    input nreset_i,
    input enable_i,

    output reg q_o
    );

    always @(posedge enable_i or negedge nreset_i) begin
        if (~nreset_i) q_o <= 0;
        else begin
            case ({j_i, k_i})
                2'b00: q_o <= q_o;
                2'b01: q_o <= 0;
                2'b10: q_o <= 1;
                2'b11: q_o <= ~q_o;
            endcase
        end
    end

endmodule