module digitlcd (
    input wire clk_i,
    input wire nreset_i,
    input wire mode1_o, mode2_o, mode3_o,


    output reg [7:0] lcd_out8, lcd_out7, lcd_out6, lcd_out5, lcd_out4, lcd_out3, lcd_out2, lcd_out1, lcd_out0,
    output reg rs, // 명령 (0) 또는 데이터 (1) 선택
    output reg rw, // 읽기 (1) 또는 쓰기 (0) 선택
    output reg en // 이동 시퀀스 활성화

    );

    localparam IDLE = 2'b00, CLOCK = 2'b01, STOPWATCH = 2'b10, TIMER = 2'b11;

    reg [71:0] lcd_data;
    reg [1:0] state;

    always @(*) begin
        lcd_out8 [7:0] <= lcd_data [71:64];
        lcd_out7 [7:0] <= lcd_data [63:56];
        lcd_out6 [7:0] <= lcd_data [55:48];
        lcd_out5 [7:0] <= lcd_data [47:40];
        lcd_out4 [7:0] <= lcd_data [39:32];
        lcd_out3 [7:0] <= lcd_data [31:24];
        lcd_out2 [7:0] <= lcd_data [23:16];
        lcd_out1 [7:0] <= lcd_data [15:8];
        lcd_out0 [7:0] <= lcd_data [7:0];
    end

    localparam [39:0] ascii_CLOCK = {40'h43_4C_4F_43_4B};
    localparam [71:0] ascii_STOPWATCH = {72'h53_54_4F_50_57_41_54_43_48}; //_4F,O
    localparam [39:0] ascii_TIMER = {40'h54_49_4D_45_52};

    initial begin
        state <= IDLE;
        rs <= 1'b0; // 명령
        rw <= 1'b0; // 쓰기
        en <= 1'b0; // 비활성화
    end

    always @(posedge clk_i or negedge nreset_i) begin
        if (!nreset_i) begin
            state <= IDLE;
            rs <= 1'b0; // 명령
            rw <= 1'b0; // 쓰기
            en <= 1'b0; // 비활성화
        end 
        else begin
            case (state)
                IDLE: begin
                    case (mode1_o)
                    2'b01: lcd_data <= {32'b0, ascii_CLOCK};
                    default : lcd_data <= {32'b0, ascii_CLOCK};
                    endcase
                    case (mode2_o)
                    2'b10: lcd_data <= ascii_STOPWATCH;
                    default : lcd_data <= {32'b0, ascii_CLOCK};
                    endcase
                    case (mode3_o)
                    2'b11: lcd_data <= {32'b0, ascii_TIMER};
                    default : lcd_data <= {32'b0, ascii_CLOCK};
                    endcase
                    rs <= 1'b1; // 데이터
                    rw <= 1'b0; // 쓰기
                    en <= 1'b1; // 활성화
                    case (mode1_o)
                    2'b01: state <= CLOCK; // state_01
                    default : state <= CLOCK;
                    endcase
                    case (mode2_o)
                    2'b10: state <= STOPWATCH; // state_10
                    default : state <= CLOCK;
                    endcase
                    case (mode3_o)
                    2'b11: state <= TIMER; // state_11
                    default : state <= CLOCK;
                    endcase
                end
            CLOCK, STOPWATCH, TIMER: begin
                // 다음 상태로 전환
                state <= IDLE;
                rs <= 1'b0; // 명령
                rw <= 1'b0; // 쓰기
                en <= 1'b0; // 비활성화
            end
        endcase
        end
    end
endmodule