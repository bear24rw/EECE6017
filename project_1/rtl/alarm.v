/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Project 1                                           *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.              *
 ***************************************************************************/

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
