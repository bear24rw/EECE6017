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

module seven_seg(
    input en,
    input [4:0] value,
    output reg [6:0] seg = 0
);

    // if the display is enabled translate the bcd lookup
    // value into the correct number, letter, or symbol
    // if the display is not enabled just keep it blank
    // default to a unused symbol to indicate an error

    always @(value, en)
        if (!en)
            seg <= 7'b1111111;
        else
            case (value)
                `BCD_0: seg <= 7'b1000000;
                `BCD_1: seg <= 7'b1111001;
                `BCD_2: seg <= 7'b0100100;
                `BCD_3: seg <= 7'b0110000;
                `BCD_4: seg <= 7'b0011001;
                `BCD_5: seg <= 7'b0010010;
                `BCD_6: seg <= 7'b0000010;
                `BCD_7: seg <= 7'b1111000;
                `BCD_8: seg <= 7'b0000000;
                `BCD_9: seg <= 7'b0010000;
                `BCD_A: seg <= 7'b0001000;
                `BCD_B: seg <= 7'b0000011;
                `BCD_C: seg <= 7'b1000110;
                `BCD_D: seg <= 7'b0100001;
                `BCD_E: seg <= 7'b0000110;
                `BCD_F: seg <= 7'b0001110;
                `BCD_G: seg <= 7'b0010000;
                `BCD_L: seg <= 7'b1000111;
                `BCD_N: seg <= 7'b0101011;
                `BCD_O: seg <= 7'b0100011;
                `BCD_R: seg <= 7'b0101111;
                `BCD_T: seg <= 7'b0000111;
                `BCD_NEG: seg <= 7'b0111111;
                `BCD_BLANK: seg <= 7'b1111111;
                default: seg <= 7'b1110110;
            endcase
                

endmodule

