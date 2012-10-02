/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   Copyright (C) 2012 by Ian Cathey                                      *
 *   Copyright (C) 2012 by Mark Labbato                                    *
 *                                                                         *
 *   Embedded System - Project 2                                           *
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
    //              START / STOP TOGGLE
    // -------------------------------------------------

    reg running = 0;

    always @(negedge KEY[3])
        running <= ~running;

    // -------------------------------------------------
    //                    COUNTER
    // -------------------------------------------------

    reg [15:0] count = 0;

    always @(posedge CLOCK_50)
        if (running)
            count <= count + 1;
        else
            count <= 0;

    // -------------------------------------------------
    //               RANDOM NUMBER GEN
    // -------------------------------------------------

    wire [7:0] rand_value;

    LFSR lfsr(
        .clk(CLOCK_50),
        .value(rand_value)
    );

    // -------------------------------------------------
    //                  DIVIDE BY 3
    // -------------------------------------------------

    wire [7:0] div_value;

    div_3 div(
        .clk(CLOCK_50),
        .in(rand_value),
        .out(div_value)
    );

    // -------------------------------------------------
    //                   SUM LAST 3
    // -------------------------------------------------

    wire [7:0] sum_value;

    sum_3 sum(
        .clk(CLOCK_50),
        .in(div_value),
        .out(sum_value)
    );

    assign LEDR = sum_value;

    // -------------------------------------------------
    //                 7-SEG DISPLAY
    // -------------------------------------------------

    // muxes all values onto the proper 7-segment display
    // depending on various input and display states

    wire [4:0] seg_0 = running ? count[3:0] : `BCD_BLANK;
    wire [4:0] seg_1 = running ? count[7:4] : `BCD_BLANK;
    wire [4:0] seg_2 = running ? count[11:8] : `BCD_BLANK;
    wire [4:0] seg_3 = running ? count[15:12] : `BCD_BLANK;

    // translates between the bcd lookup values and the
    // actual segments on the displays

    seven_seg s0(seg_0, HEX0);
    seven_seg s1(seg_1, HEX1);
    seven_seg s2(seg_2, HEX2);
    seven_seg s3(seg_3, HEX3);
            
endmodule

// vim: set textwidth=60:

