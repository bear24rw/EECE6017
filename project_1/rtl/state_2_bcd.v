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

module state_2_bcd(
    input [1:0] state,
    output reg [4:0] bcd_0 = 0,
    output reg [4:0] bcd_1 = 0,
    output reg [4:0] bcd_2 = 0,
    output reg [4:0] bcd_3 = 0
);

    // we want to display human readable state
    // indicators on the 4 7-segment displays
    // simply look up which state the system is
    // in and assign the 4 displays the proper
    // bcd lookup value

    always @(state) begin
        case (state)
            `STATE_NORMAL: begin
                bcd_3 = `BCD_G;
                bcd_2 = `BCD_O;
                bcd_1 = `BCD_O;
                bcd_0 = `BCD_D;
            end
            `STATE_BORDERLINE: begin
                bcd_3 = `BCD_B;
                bcd_2 = `BCD_O;
                bcd_1 = `BCD_R;
                bcd_0 = `BCD_D;
            end
            `STATE_ATTENTION: begin
                bcd_3 = `BCD_A;
                bcd_2 = `BCD_T;
                bcd_1 = `BCD_T;
                bcd_0 = `BCD_N;
            end
            `STATE_EMERGENCY: begin
                bcd_3 = `BCD_F;
                bcd_2 = `BCD_A;
                bcd_1 = `BCD_1;
                bcd_0 = `BCD_L;
            end
            default: begin
                bcd_3 = `BCD_F;
                bcd_2 = `BCD_F;
                bcd_1 = `BCD_F;
                bcd_0 = `BCD_F;
            end
        endcase
    end

endmodule
