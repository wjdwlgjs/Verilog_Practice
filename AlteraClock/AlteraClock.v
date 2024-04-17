module AlteraClock(
    // buttons and switches
    input key1_i,
    input key2_i,
    input key3_i,
    input set_switch_i,
    input master_nreset_switch_i,

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

    