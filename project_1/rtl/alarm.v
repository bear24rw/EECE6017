`include "constants.h"

module alarm (
    input clk,
    input [1:0] state,
    output [9:0] leds
);

    // we need two distinct alarms for the ATTENTION and
    // EMERGENCY states. to achieve this we use two different
    // pulse speeds as well as different patterns

    // bitmask patterns
    `define ATTN_PAT    10'b1010110101
    `define EMER_PAT    10'b1111111111

    // output pulse from the pulse_led modules
    wire pulse_led_slow;
    wire pulse_led_fast;

    // override the default step size to get two difference pulse speeds
    pulse_led #(.step_size(10000)) pulse_slow (clk, pulse_led_slow);
    pulse_led #(.step_size(60000)) pulse_fast (clk, pulse_led_fast);

    // check which state we are in and mask the ouput
    assign leds = 
        (state == `STATE_ATTENTION) ? {10{pulse_led_slow}} & `ATTN_PAT :
        (state == `STATE_EMERGENCY) ? {10{pulse_led_fast}} & `EMER_PAT :
        {10{1'b0}};

endmodule
