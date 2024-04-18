/* `include "AlteraClock/CombinedModule.v"
`include "AlteraClock/PulseGenerator.v" */

module AlteraClock(
    // buttons and switches
    input key0_i,
    input key1_i,
    input key2_i,
    input key3_i,
    input set_switch_i,
    input master_nreset_switch_i,
    input disp_on_switch_i,

    // internal inputs
    input clk_50mhz_i,
    
    output [6:0] centisec_7seg_o,
    output [6:0] decisec_7seg_o,

    output [6:0] sec_7seg_o,
    output [6:0] decasec_7seg_o,
    
    output [6:0] min_7seg_o,
    output [6:0] decamin_7seg_o,

    output [6:0] hr_7seg_o,
    output [6:0] decahr_7seg_o

    );

    wire blink_lessthansec;
    wire blink_sec;
    wire blink_min;
    wire blink_hr;

    wire clk_100hz;
    PulseGenerator ClkGen(
        .clk_i(clk_50mhz_i),
        .nreset_i(master_nreset_switch_i),
        .period_i(32'b111101000010010000), 
        
        .pulse_o(clk_100hz)
    );

    wire [6:0] temp_centisec_7seg;
    wire [6:0] temp_decisec_7seg;

    wire [6:0] temp_sec_7seg;
    wire [6:0] temp_decasec_7seg;
    
    wire [6:0] temp_min_7seg;
    wire [6:0] temp_decamin_7seg;

    wire [6:0] temp_hr_7seg;
    wire [6:0] temp_decahr_7seg;

    CombinedModule MainModule(
        .key0_i(key0_i),
        .key1_i(key1_i),
        .key2_i(key2_i),
        .key3_i(key3_i),
        .set_switch_i(set_switch_i),
        .disp_on_switch_i(disp_on_switch_i),

        .clk_i(clk_100hz),
        .nreset_i(master_nreset_switch_i),

        .centisec_7seg_o(temp_centisec_7seg),
        .decisec_7seg_o(temp_decisec_7seg),

        .sec_7seg_o(temp_sec_7seg),
        .decasec_7seg_o(temp_decasec_7seg),
        
        .min_7seg_o(temp_min_7seg),
        .decamin_7seg_o(temp_decamin_7seg),

        .hr_7seg_o(temp_hr_7seg),
        .decahr_7seg_o(temp_decahr_7seg),

        .blink_lessthansec_o(blink_lessthansec),
        .blink_sec_o(blink_sec),
        .blink_min_o(blink_min),
        .blink_hr_o(blink_hr)
    );

    wire blinking_pulse;
    PulseGeneratorSmall Blinker(
        .clk_i(clk_100hz),
        .nreset_i(blink_lessthansec | blink_sec | blink_min | blink_hr),
        .period_i(8'b110010), // 00110010
        
        .pulse_o(blinking_pulse)
    );

    assign centisec_7seg_o = temp_centisec_7seg | {7{blinking_pulse & blink_lessthansec}} | ~{7{disp_on_switch_i}};
    assign decisec_7seg_o = temp_decisec_7seg | {7{blinking_pulse & blink_lessthansec}} | ~{7{disp_on_switch_i}};
    assign sec_7seg_o = temp_sec_7seg | {7{blinking_pulse & blink_sec}} | ~{7{disp_on_switch_i}};
    assign decasec_7seg_o = temp_decasec_7seg | {7{blinking_pulse & blink_sec}} | ~{7{disp_on_switch_i}};
    assign min_7seg_o = temp_min_7seg | {7{blinking_pulse & blink_min}} | ~{7{disp_on_switch_i}};
    assign decamin_7seg_o = temp_decamin_7seg | {7{blinking_pulse & blink_min}} | ~{7{disp_on_switch_i}};
    assign hr_7seg_o = temp_hr_7seg | {7{blinking_pulse & blink_hr}} | ~{7{disp_on_switch_i}};
    assign decahr_7seg_o = temp_decahr_7seg | {7{blinking_pulse & blink_hr}} | ~{7{disp_on_switch_i}};

    
endmodule