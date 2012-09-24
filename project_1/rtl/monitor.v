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

module monitor(
    input rst,
    input en,

    input [3:0] temp_value_ones,
    input [3:0] temp_value_tens,
    input [3:0] temp_value_huns,
    input temp_value_sign,

    input [3:0] temp_delta_ones,
    input [3:0] temp_delta_tens,
    input [3:0] temp_delta_huns,
    input temp_delta_sign,

    output [1:0] state
);

    // -------------------------------------------------
    //              VALUE COUNTER
    // -------------------------------------------------

    // we need at least two values before our delta is valid
    // this register counts up to tell when we have 2 values
    reg [1:0] value_count = 0;

    // the 'en' line going high is our trigger that the system
    // received a new value
    always @(posedge en, posedge rst) begin
        if (rst) begin
            value_count = 0;
        end else begin
            // have we received two values yet?
            if (value_count < 2)
                value_count = value_count + 1;
        end
    end

    // -------------------------------------------------
    //              MODE CHANGE DETECT
    // -------------------------------------------------

    // we need to detect if the mode switch goes either from
    // low to high or high to low. since we don't have dual edge 
    // sensitive flip flops we have to use two single edge

    reg mode_changed_pos = 0; // positive edge detected
    reg mode_changed_neg = 0; // negative edge detected

    // detect positive edges
    always @(posedge temp_value_sign, posedge rst)
        if (rst) mode_changed_pos = 0;
        else mode_changed_pos = 1;

    // detect negative edges
    always @(negedge temp_value_sign, posedge rst)
        if (rst) mode_changed_neg = 0;
        else mode_changed_neg = 1;

    // if either a positive or negative edge happened the mode changed
    assign mode_changed = mode_changed_neg | mode_changed_pos;

    // -------------------------------------------------
    //              STATE MUX
    // -------------------------------------------------
 
    // express the thresholds in hex because it is the same
    // as 3 bcd digits catted together
    `define T5      12'h050
    `define T40     12'h400
    `define T47     12'h470
    `define T50     12'h500

    // cat the bcd digits together so we can do easy comparisons
    wire [11:0] temp_value_bcd = {temp_value_huns, temp_value_tens, temp_value_ones};
    wire [11:0] temp_delta_bcd = {temp_delta_huns, temp_delta_tens, temp_delta_ones};

    // priority mux to determine what state we're in
    // 1) if the mode changed it's an EMERGENCY
    // 2) if we have monitored at least 2 values
    //    and the monitor is enabled and the delta
    //    between the last two reading is > 5, it's
    //    an EMERGENCY
    // 3) temp < 40                 NORMAL
    // 4) temp >= 40 and temp < 47  BORDERLINE
    // 5) temp >= 47 and temp < 50  ATTENTION
    // 6) temp >= 50                EMERGENCY

    assign state = 
        (mode_changed)                                      ? `STATE_EMERGENCY :
        (value_count == 2 && en && temp_delta_bcd > `T5)    ? `STATE_EMERGENCY :
        (temp_value_bcd <  `T40)                            ? `STATE_NORMAL :
        (temp_value_bcd >= `T40 && temp_value_bcd < `T47)   ? `STATE_BORDERLINE :
        (temp_value_bcd >= `T47 && temp_value_bcd < `T50)   ? `STATE_ATTENTION :
        (temp_value_bcd >= `T50)                            ? `STATE_EMERGENCY : 0;

endmodule
