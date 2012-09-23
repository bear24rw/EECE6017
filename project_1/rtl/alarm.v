`include "constants.h"

module alarm (
    input clk,
    input [1:0] state,
    output [9:0] leds
);

    wire pulse_led_slow;
    wire pulse_led_fast;

    pulse_led #(.step_size(10000)) pulse_slow (clk, pulse_led_slow);
    pulse_led #(.step_size(60000)) pulse_fast (clk, pulse_led_fast);

    assign leds = 
        (state == `STATE_ATTENTION) ? {5 {1'b0,pulse_led_slow}} :
        (state == `STATE_EMERGENCY) ? {10{pulse_led_fast}} :
        {10{1'b0}};

endmodule
