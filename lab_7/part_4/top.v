module top (
    input clk, reset, send,
    input [3:0] letter,
    output reg led
);


    parameter STATE_IDLE = 0;
    parameter STATE_DOT = 1;
    parameter STATE_DASH_1 = 2;
    parameter STATE_DASH_2 = 3;
    parameter STATE_DASH_3 = 4;

    parameter A = 4'b0000;
    parameter B = 4'b0001;
    parameter C = 4'b0010;
    parameter D = 4'b0011;
    parameter E = 4'b0100;
    parameter F = 4'b0101;
    parameter G = 4'b0110;
    parameter H = 4'b0111;

    reg [3:0] next_state;
    reg [3:0] cur_state = STATE_IDLE;
    reg [3:0] bit_pos = 4;

    reg [3:0] codes [7:0];
   
    // codes are reversed
    initial begin
        codes[A] <= 4'bzz01;
        codes[B] <= 4'b1110;
        codes[C] <= 4'b1010;
        codes[D] <= 4'bz110;
        codes[E] <= 4'bzzz1;
        codes[F] <= 4'b1011;
        codes[G] <= 4'bz100;
        codes[H] <= 4'b1111;
    end

    always @(cur_state, send) 
    begin: state_table

        case (cur_state)

            STATE_DOT: begin
                led <= 1;
                next_state <= STATE_IDLE;
            end

            STATE_DASH_1: begin
                led <= 1;
                next_state <= STATE_DASH_2;
            end

            STATE_DASH_2:
                next_state <= STATE_DASH_3;

            STATE_DASH_3:
                next_state <= STATE_IDLE;

            STATE_IDLE: begin
                led <= 0;

                if (send) bit_pos = 0;

                if (bit_pos < 4) begin

                    case (codes[letter][bit_pos])
                        1'b1: next_state <= STATE_DOT;
                        1'b0: next_state <= STATE_DASH_1;
                        default: next_state <= STATE_IDLE;
                    endcase

                    bit_pos = bit_pos + 1'b0001;
                end
            end

            default:
                next_state = STATE_IDLE;

        endcase
    end

    always @(posedge clk)
    begin: state_FFs
        if (reset)
            cur_state <= STATE_IDLE;
        else
            cur_state <= next_state;
    end

endmodule
