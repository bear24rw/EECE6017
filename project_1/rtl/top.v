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
   
    // invert the keys because we want to deal with 
    // positive edge logic

    assign rst = ~KEY[0];
    assign enter_key = ~KEY[3];

    // temperature value is in bcd so we only need the
    // first 4 switches

    wire [3:0] temp_sw = SW[3:0];

    // switch 9 is used to indicate the sign or 'mode'
    // of our temperature values

    assign temp_value_sign = SW[9];

    // status / debug leds

    assign LEDG[7:6] = input_state;
    assign LEDG[5:4] = disp_mode;
    assign LEDG[3:2] = state;
    assign LEDG[0] = new_number;

    // -------------------------------------------------
    //              1 HZ CLOCK
    // -------------------------------------------------

    // divide the 50MHz clock down to 1Hz
    // if we are in a simulation we don't want to wait
    // 25 millions clocks so we override the parameter
    // with 5

    wire clk_1hz;

    `ifdef SIMULATION
        clk_div #(.COUNT(5)) clk_div(CLOCK_50, clk_1hz);
    `else
        clk_div clk_div(CLOCK_50, clk_1hz);
    `endif

    // -------------------------------------------------
    //              DISPLAY MODE
    // -------------------------------------------------

    // cycle through 3 display states:
    // TEMP - display the most recently read temperature
    // DELTA - display the difference between the last two
    // STATE - display ascii text telling what state we are in

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

    // clocks in new bcd temperature values from the
    // switches. 'input_state' is which digit we are
    // on. 'current_input_value' is the real time value
    // on the input switches. 'new_number' is a flag
    // that goes high when we finish clocking in a new
    // number. 'temp_value_*' are the bcd digits of the
    // number.

    wire [1:0] input_state;
    wire [3:0] current_input_value;
    wire new_number;

    wire [3:0] temp_value_ones;
    wire [3:0] temp_value_tens;
    wire [3:0] temp_value_huns;

    wire [3:0] temp_value_ones_old;
    wire [3:0] temp_value_tens_old;
    wire [3:0] temp_value_huns_old;

    temp_input temp_input(
        .rst(rst),
        .value(temp_sw),
        .enter(enter_key),
        .current_value(current_input_value),
        .input_state(input_state),
        .new_number(new_number),

        .temp_value_ones(temp_value_ones),
        .temp_value_tens(temp_value_tens),
        .temp_value_huns(temp_value_huns),

        .temp_value_ones_old(temp_value_ones_old),
        .temp_value_tens_old(temp_value_tens_old),
        .temp_value_huns_old(temp_value_huns_old)
    );

    // -------------------------------------------------
    //              TEMP CHANGE
    // -------------------------------------------------

    // calculates the difference between the most current
    // temperature reading and the one previous to it.
    // 'temp_delta_sign' indicates a negative result when 1

    wire [3:0] temp_delta_ones;
    wire [3:0] temp_delta_tens;
    wire [3:0] temp_delta_huns;
    wire temp_delta_sign;

    bcd_sub bcd_sub(
        .a_huns(temp_value_huns),
        .a_tens(temp_value_tens),
        .a_ones(temp_value_ones),

        .b_huns(temp_value_huns_old),
        .b_tens(temp_value_tens_old),
        .b_ones(temp_value_ones_old),

        .out_huns(temp_delta_huns),
        .out_tens(temp_delta_tens),
        .out_ones(temp_delta_ones),

        .negative(temp_delta_sign)
    );

    // -------------------------------------------------
    //              TEMP MONITOR
    // -------------------------------------------------

    // monitors the state of the current temperature,
    // the delta of current temperature and previous
    // temperature, and the system mode (temp_value_sign)
    // and determines which state the system is in.

    wire [1:0] state;

    monitor monitor(
        .rst(rst),
        .en(new_number),

        .temp_value_ones(temp_value_ones),
        .temp_value_tens(temp_value_tens),
        .temp_value_huns(temp_value_huns),
        .temp_value_sign(temp_value_sign),

        .temp_delta_ones(temp_delta_ones),
        .temp_delta_tens(temp_delta_tens),
        .temp_delta_huns(temp_delta_huns),
        .temp_delta_sign(temp_delta_sign),

        .state(state)
    );

    // -------------------------------------------------
    //              STATE TO BCD
    // -------------------------------------------------

    // converts the current system state to human readable
    // text on the 4 7-segment displays

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

    // converts the negative signs to their proper bcd
    // lookup value

    wire [4:0] temp_value_sign_bcd;
    wire [4:0] temp_delta_sign_bcd;
    assign temp_value_sign_bcd = temp_value_sign ? `BCD_NEG : `BCD_BLANK;
    assign temp_delta_sign_bcd = temp_delta_sign ? `BCD_NEG : `BCD_BLANK;

    // -------------------------------------------------
    //                  ALARM
    // -------------------------------------------------

    // outputs different 'alarms' to the red leds depending
    // on which state the system is in

    alarm alarm(
        .clk(CLOCK_50),
        .state(state),
        .leds(LEDR)
    );

    // -------------------------------------------------
    //                  7 SEG MUX
    // -------------------------------------------------

    // muxes all values onto the proper 7-segment display
    // depending on various input and display states

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

    // translates between the bcd lookup values and the
    // actual segments on the displays

    seven_seg s0(seg_0_en, seg_0, HEX0);
    seven_seg s1(seg_1_en, seg_1, HEX1);
    seven_seg s2(seg_2_en, seg_2, HEX2);
    seven_seg s3(seg_3_en, seg_3, HEX3);
            
endmodule
