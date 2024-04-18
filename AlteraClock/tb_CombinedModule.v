`include "AlteraClock/CombinedModule.v"
`timescale 1ns/1ns

module tb_CombinedModule();

    reg tb_key0;
    reg tb_key1;
    reg tb_key2;
    reg tb_key3;
    reg tb_set_switch;
    reg tb_disp_on_switch;

    reg tb_clk;
    reg tb_nreset;

    wire [6:0] tb_centisec_7seg;
    wire [6:0] tb_decisec_7seg;

    wire [6:0] tb_sec_7seg;
    wire [6:0] tb_decasec_7seg;
    
    wire [6:0] tb_min_7seg;
    wire [6:0] tb_decamin_7seg;

    wire [6:0] tb_hr_7seg;
    wire [6:0] tb_decahr_7seg;

    wire tb_blink_lessthansec;
    wire tb_blink_sec;
    wire tb_blink_min;
    wire tb_blink_hr;

    CombinedModule TestModule(
        .key0_i(tb_key0),
        .key1_i(tb_key1),
        .key2_i(tb_key2),
        .key3_i(tb_key3),
        .set_switch_i(tb_set_switch),
        .disp_on_switch_i(tb_disp_on_switch),

        .clk_i(tb_clk),
        .nreset_i(tb_nreset),

        .centisec_7seg_o(tb_centisec_7seg),
        .decisec_7seg_o(tb_decisec_7seg),

        .sec_7seg_o(tb_sec_7seg),
        .decasec_7seg_o(tb_decasec_7seg),
        
        .min_7seg_o(tb_min_7seg),
        .decamin_7seg_o(tb_decamin_7seg),

        .hr_7seg_o(tb_hr_7seg),
        .decahr_7seg_o(tb_decahr_7seg),

        .blink_lessthansec_o(tb_blink_lessthansec),
        .blink_sec_o(tb_blink_sec),
        .blink_min_o(tb_blink_min),
        .blink_hr_o(tb_blink_hr)
    );

    always #10 tb_clk <= ~tb_clk;
    always @(posedge (tb_key0 | tb_key1 | tb_key2 | tb_key3)) #34 {tb_key0, tb_key1, tb_key2, tb_key3} <= 4'b1111;

    reg [5:0] switch_sim;

    initial begin
        $dumpfile("AlteraClock/BuildFiles/tb_CombinedModule.vcd");
        $dumpvars(0, tb_CombinedModule);
        
        tb_key0 = 1;
        tb_key1 = 1;
        tb_key2 = 1;
        tb_key3 = 1;
        tb_set_switch = 0;
        tb_disp_on_switch = 0;

        switch_sim = 6'b0;

        tb_clk = 0;
        tb_nreset = 0;

        #20 tb_nreset = 1;

        for (integer i = 0; i < 80; i = i + 1) begin
            switch_sim <= switch_sim + 1;
            #60
            {tb_disp_on_switch, tb_set_switch, tb_key3, tb_key2, tb_key1, tb_key0} <= {switch_sim[5:4], ~switch_sim[3:0]};
        end

        $finish;
    end
endmodule

