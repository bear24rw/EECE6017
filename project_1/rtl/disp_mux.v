`include "constants.h"

module disp_mux(
    input clk,

    input [1:0] input_state,
    input [1:0] disp_mode,

    input [3:0] current_input_value,

    input [3:0] temp_value_ones,
    input [3:0] temp_value_tens,
    input [3:0] temp_value_huns,
    input [4:0] temp_value_sign_bcd,

    input [3:0] temp_delta_ones,
    input [3:0] temp_delta_tens,
    input [3:0] temp_delta_huns,
    input [4:0] temp_delta_sign_bcd,

    input [4:0] state_bcd_0,
    input [4:0] state_bcd_1,
    input [4:0] state_bcd_2,
    input [4:0] state_bcd_3,

    output [4:0] seg_0,
    output [4:0] seg_1,
    output [4:0] seg_2,
    output [4:0] seg_3,

    output seg_0_en,
    output seg_1_en,
    output seg_2_en,
    output seg_3_en
);

    // for each 7-segment display we need to figure out what to display
    // we use a priority mux to determine which value should be displayed
    // when according to the input state and display mode

    assign seg_0 =
        (input_state == `INPUT_STATE_ONES) ? current_input_value :
        (input_state == `INPUT_STATE_TENS) ? temp_value_ones :  
        (input_state == `INPUT_STATE_HUNS) ? temp_value_ones :
        (disp_mode == `DISP_MODE_TEMP)     ? temp_value_ones :
        (disp_mode == `DISP_MODE_DELTA)    ? temp_delta_ones :
        (disp_mode == `DISP_MODE_STATE)    ? state_bcd_0 : 0;
    assign seg_1 =
        (input_state == `INPUT_STATE_ONES) ? `BCD_BLANK :
        (input_state == `INPUT_STATE_TENS) ? current_input_value :  
        (input_state == `INPUT_STATE_HUNS) ? temp_value_tens :
        (disp_mode == `DISP_MODE_TEMP)     ? temp_value_tens :
        (disp_mode == `DISP_MODE_DELTA)    ? temp_delta_tens :
        (disp_mode == `DISP_MODE_STATE)    ? state_bcd_1 : 0;
    assign seg_2 =
        (input_state == `INPUT_STATE_ONES) ? `BCD_BLANK :
        (input_state == `INPUT_STATE_TENS) ? `BCD_BLANK :  
        (input_state == `INPUT_STATE_HUNS) ? current_input_value :
        (disp_mode == `DISP_MODE_TEMP)     ? temp_value_huns :
        (disp_mode == `DISP_MODE_DELTA)    ? temp_delta_huns :
        (disp_mode == `DISP_MODE_STATE)    ? state_bcd_2 : 0;
    assign seg_3 =
        (input_state == `INPUT_STATE_ONES) ? temp_value_sign_bcd :
        (input_state == `INPUT_STATE_TENS) ? temp_value_sign_bcd :  
        (input_state == `INPUT_STATE_HUNS) ? temp_value_sign_bcd :
        (disp_mode == `DISP_MODE_TEMP)     ? temp_value_sign_bcd :
        (disp_mode == `DISP_MODE_DELTA)    ? temp_delta_sign_bcd :
        (disp_mode == `DISP_MODE_STATE)    ? state_bcd_3 : 0;

    // we want to pulse the current input value
    wire pulse_led_slow;
    pulse_led #(.step_size(10000)) pulse_slow (clk, pulse_led_slow);
   
    // if any of the displays are currently showing the current input value
    // we want to pulse their enable lines, otherwise just keep them enabled
    assign seg_0_en = (input_state == `INPUT_STATE_ONES) ? pulse_led_slow : 1;
    assign seg_1_en = (input_state == `INPUT_STATE_TENS) ? pulse_led_slow : 1;
    assign seg_2_en = (input_state == `INPUT_STATE_HUNS) ? pulse_led_slow : 1;
    assign seg_3_en = 1;

endmodule
