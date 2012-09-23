`include "constants.h"

module top(
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [7:0] LEDG,
    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);

    // -------------------------------------------------
    //              KEY & SW ASSIGNMENTS
    // -------------------------------------------------
    
    assign rst = ~KEY[1];
    assign enter_key = ~KEY[3];

    wire [3:0] temp_sw = SW[3:0];

    assign temp_value_sign = SW[9];

    assign LEDG[7:6] = input_state;
    assign LEDG[5:4] = disp_mode;
    assign LEDG[3:2] = state;

    // -------------------------------------------------
    //              1 HZ CLOCK
    // -------------------------------------------------

    // divide the 50MHz clock down to 1Hz
    wire clk_1hz;
    `ifdef SIMULATION
        clk_div #(.COUNT(5)) clk_div(CLOCK_50, clk_1hz);
    `else
        clk_div clk_div(CLOCK_50, clk_1hz);
    `endif

    // -------------------------------------------------
    //              DISPLAY MODE
    // -------------------------------------------------

    reg [1:0] disp_mode = `DISP_MODE_TEMP;
    always @(posedge clk_1hz)
        case (disp_mode)
            `DISP_MODE_TEMP:  disp_mode = `DISP_MODE_DELTA;
            `DISP_MODE_DELTA: disp_mode = `DISP_MODE_STATE;
            `DISP_MODE_STATE: disp_mode = `DISP_MODE_TEMP;
        endcase

    // -------------------------------------------------
    //              TEMP INPUT
    // -------------------------------------------------

    wire [1:0] input_state;
    wire [3:0] current_input_value;

    wire [3:0] temp_value_ones;
    wire [3:0] temp_value_tens;
    wire [3:0] temp_value_huns;

    wire [3:0] temp_value_ones_old;
    wire [3:0] temp_value_tens_old;
    wire [3:0] temp_value_huns_old;

    temp_input ti(
        .rst(rst),
        .value(temp_sw),
        .enter(enter_key),
        .current_value(current_input_value),
        .input_state(input_state),

        .temp_value_ones(temp_value_ones),
        .temp_value_tens(temp_value_tens),
        .temp_value_huns(temp_value_huns),

        .temp_value_ones_old(temp_value_ones_old),
        .temp_value_tens_old(temp_value_tens_old),
        .temp_value_huns_old(temp_value_huns_old)
    );

    // -------------------------------------------------
    //              TEMP MONITOR
    // -------------------------------------------------

    wire [1:0] state;
    wire temp_delta_sign;

    wire [3:0] temp_delta_ones;
    wire [3:0] temp_delta_tens;
    wire [3:0] temp_delta_huns;

    // monitor is only enabled when we are done inputting the value
    assign monitor_en = (input_state == `INPUT_STATE_DONE);

    monitor monitor(
        .clk(clk_1hz),
        .rst(rst),
        .en(monitor_en),

        .temp_value_ones(temp_value_ones),
        .temp_value_tens(temp_value_tens),
        .temp_value_huns(temp_value_huns),
        .temp_value_sign(temp_value_sign),

        .temp_value_ones_old(temp_value_ones_old),
        .temp_value_tens_old(temp_value_tens_old),
        .temp_value_huns_old(temp_value_huns_old),

        .temp_delta_ones(temp_delta_ones),
        .temp_delta_tens(temp_delta_tens),
        .temp_delta_huns(temp_delta_huns),
        .temp_delta_sign(temp_delta_sign),

        .state(state)
    );

    assign LEDG[0] = temp_value_sign;

    // -------------------------------------------------
    //              STATE TO BCD
    // -------------------------------------------------

    wire [4:0] state_bcd_0;
    wire [4:0] state_bcd_1;
    wire [4:0] state_bcd_2;
    wire [4:0] state_bcd_3;

    state_2_bcd s2b(
        .state(state),
        .bcd_0(state_bcd_0),
        .bcd_1(state_bcd_1),
        .bcd_2(state_bcd_2),
        .bcd_3(state_bcd_3)
    );

    // -------------------------------------------------
    //              TEMP SIGN TO BCD
    // -------------------------------------------------

    wire [4:0] temp_value_sign_bcd;
    wire [4:0] temp_delta_sign_bcd;
    assign temp_value_sign_bcd = temp_value_sign ? `BCD_NEG : `BCD_BLANK;
    assign temp_delta_sign_bcd = temp_delta_sign ? `BCD_NEG : `BCD_BLANK;

    // -------------------------------------------------
    //                  ALARM
    // -------------------------------------------------

    alarm alarm(
        .clk(CLOCK_50),
        .state(state),
        .leds(LEDR)
    );

    // -------------------------------------------------
    //                  7 SEGS
    // -------------------------------------------------

    wire [4:0] seg_0;
    wire [4:0] seg_1;
    wire [4:0] seg_2;
    wire [4:0] seg_3;
    wire seg_0_en;
    wire seg_1_en;
    wire seg_2_en;
    wire seg_3_en;

    disp_mux dm(
        .clk(CLOCK_50),

        .input_state(input_state),
        .disp_mode(disp_mode),

        .current_input_value(current_input_value),

        .temp_value_ones(temp_value_ones),
        .temp_value_tens(temp_value_tens),
        .temp_value_huns(temp_value_huns),
        .temp_value_sign_bcd(temp_value_sign_bcd),

        .temp_delta_ones(temp_delta_ones),
        .temp_delta_tens(temp_delta_tens),
        .temp_delta_huns(temp_delta_huns),
        .temp_delta_sign_bcd(temp_delta_sign_bcd),

        .state_bcd_0(state_bcd_0),
        .state_bcd_1(state_bcd_1),
        .state_bcd_2(state_bcd_2),
        .state_bcd_3(state_bcd_3),

        .seg_0(seg_0),
        .seg_1(seg_1),
        .seg_2(seg_2),
        .seg_3(seg_3),

        .seg_0_en(seg_0_en),
        .seg_1_en(seg_1_en),
        .seg_2_en(seg_2_en),
        .seg_3_en(seg_3_en)
    );

    seven_seg s0(seg_0_en, seg_0, HEX0);
    seven_seg s1(seg_1_en, seg_1, HEX1);
    seven_seg s2(seg_2_en, seg_2, HEX2);
    seven_seg s3(seg_3_en, seg_3, HEX3);
            
endmodule
