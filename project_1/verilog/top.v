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
    //              1 HZ CLOCK
    // -------------------------------------------------

    // divide the 50MHz clock down to 1Hz
    wire clk_1hz;
    clk_div clk_div(CLOCK_50, clk_1hz);

    // -------------------------------------------------
    //              DISPLAY MODE
    // -------------------------------------------------

    reg [2:0] disp_mode = 1;
    always @(posedge clk_1hz)
        case (disp_mode)
            `DISP_MODE_TEMP:  disp_mode = `DISP_MODE_DELTA;
            `DISP_MODE_DELTA: disp_mode = `DISP_MODE_STATE;
            `DISP_MODE_STATE: disp_mode = `DISP_MODE_TEMP;
        endcase

    // -------------------------------------------------
    //              TEMP MODE
    // -------------------------------------------------

    // toggle the mode we're in (pos or neg temps)
    // temp_value_sign = 1 : negative temps
    // temp_value_sign = 0 : positive temps
    reg temp_value_sign = 0;
    always @(posedge KEY[0])
        temp_value_sign <= ~temp_value_sign;

    // display it on LEDG0
    assign LEDG[0] = temp_value_sign;

    // -------------------------------------------------
    //              TEMP VALUE
    // -------------------------------------------------

    reg [5:0] temp;
    reg [3:0] temp_frac;

    always @(SW) begin
        temp <= SW[9:4];
        if (SW[3:0] < 9)
            temp_frac <= SW[3:0];
        else
            temp_frac <= 9;
    end

    // -------------------------------------------------
    //              TEMP MONITOR
    // -------------------------------------------------

    wire [3:0] state;
    wire [5:0] temp_delta;
    wire [3:0] temp_delta_frac;
    wire temp_delta_sign;

    monitor monitor(
        .clk(clk_1hz),
        .mode(temp_value_sign),
        .temp(temp),
        .temp_frac(temp_frac),
        .temp_delta(temp_delta),
        .temp_delta_frac(temp_delta_frac),
        .temp_delta_sign(temp_delta_sign),
        .state(state)
    );

    // -------------------------------------------------
    //              TEMP TO BCD
    // -------------------------------------------------

    // convert the temperature into BCD
    wire [3:0] temp_value_bcd_tens;
    wire [3:0] temp_value_bcd_ones;
    wire [3:0] temp_value_bcd_frac;

    bin_2_bcd bcd(
        .bin(temp),
        .ones(temp_value_bcd_ones),
        .tens(temp_value_bcd_tens),
        .hundreds()
    );

    bin_2_bcd bcd_frac(
        .bin(temp_frac),
        .ones(temp_value_bcd_frac),
        .tens(),
        .hundreds()
    );
    
    // -------------------------------------------------
    //              TEMP DELTA TO BCD
    // -------------------------------------------------

    // convert the temperature into BCD
    wire [3:0] temp_delta_bcd_tens;
    wire [3:0] temp_delta_bcd_ones;
    wire [3:0] temp_delta_bcd_frac;

    bin_2_bcd delta_bcd(
        .bin(temp_delta),
        .ones(temp_delta_bcd_ones),
        .tens(temp_delta_bcd_tens),
        .hundreds()
    );

    bin_2_bcd delta_bcd_frac(
        .bin(temp_delta_frac),
        .ones(temp_delta_bcd_frac),
        .tens(),
        .hundreds()
    );

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
    wire [4:0] temp_delta_bcd_sign;
    assign temp_value_sign_bcd = temp_value_sign ? `BCD_NEG : `BCD_BLANK;
    assign temp_delta_bcd_sign = temp_delta_sign ? `BCD_NEG : `BCD_BLANK;


    // -------------------------------------------------
    //                  7 SEGS
    // -------------------------------------------------

    wire [4:0] seg_0;
    wire [4:0] seg_1;
    wire [4:0] seg_2;
    wire [4:0] seg_3;

    // mux the displays depending on what display mode were in
    assign seg_0 = 
        (disp_mode == `DISP_MODE_TEMP)  ? temp_value_bcd_frac :
        (disp_mode == `DISP_MODE_DELTA) ? temp_delta_bcd_frac :
        (disp_mode == `DISP_MODE_STATE) ? state_bcd_0 : 0;
    assign seg_1 = 
        (disp_mode == `DISP_MODE_TEMP)  ? temp_value_bcd_ones :
        (disp_mode == `DISP_MODE_DELTA) ? temp_delta_bcd_ones :
        (disp_mode == `DISP_MODE_STATE) ? state_bcd_1 : 0;
    assign seg_2 = 
        (disp_mode == `DISP_MODE_TEMP)  ? temp_value_bcd_tens :
        (disp_mode == `DISP_MODE_DELTA) ? temp_delta_bcd_tens :
        (disp_mode == `DISP_MODE_STATE) ? state_bcd_2 : 0;
    assign seg_3 = 
        (disp_mode == `DISP_MODE_TEMP)  ? temp_value_sign_bcd :
        (disp_mode == `DISP_MODE_DELTA) ? temp_delta_bcd_sign :
        (disp_mode == `DISP_MODE_STATE) ? state_bcd_3 : 0;

    seven_seg s0(seg_0, HEX0);
    seven_seg s1(seg_1, HEX1);
    seven_seg s2(seg_2, HEX2);
    seven_seg s3(seg_3, HEX3);

    // -------------------------------------------------
    //                  ALARM
    // -------------------------------------------------
    
    wire pulse_led_slow;
    wire pulse_led_fast;

    pulse_led #(.step_size(10000)) pulse_slow (CLOCK_50, pulse_led_slow);
    pulse_led #(.step_size(60000)) pulse_fast (CLOCK_50, pulse_led_fast);

    assign LEDR[9:0] = 
        (state == `STATE_ATTENTION) ? {5 {1'b0,pulse_led_slow}} :
        (state == `STATE_EMERGENCY) ? {10{pulse_led_fast}} :
        {10{1'b0}};
            
endmodule
