`include "constants.h"

module state_2_bcd(
    input [3:0] state,
    output reg [4:0] bcd_0,
    output reg [4:0] bcd_1,
    output reg [4:0] bcd_2,
    output reg [4:0] bcd_3
);

    always @(state) begin
        case (state)
            STATE_NORMAL: begin
                bcd_3 = BCD_G;
                bcd_2 = BCD_O;
                bcd_1 = BCD_O;
                bcd_0 = BCD_D;
            end
            STATE_BORDERLINE: begin
                bcd_3 = BCD_B;
                bcd_2 = BCD_O;
                bcd_1 = BCD_R;
                bcd_0 = BCD_D;
            end
            STATE_ATTENTION: begin
                bcd_3 = BCD_A;
                bcd_2 = BCD_T;
                bcd_1 = BCD_T;
                bcd_0 = BCD_N;
            end
            STATE_EMERGENCY: begin
                bcd_3 = BCD_F;
                bcd_2 = BCD_A;
                bcd_1 = BCD_1;
                bcd_0 = BCD_L;
            end
        endcase
    end

endmodule
