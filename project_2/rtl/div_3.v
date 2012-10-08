/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
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

module div_3(
    input clk,
    input rst,
    input en,
    input signed [7:0] in,
    output signed [7:0] out
);

    // we want to multiply by (1/3)
    // we need to figure out what (1/3) is in binary
    // 6 fractional bits give 2**6 = 64 values
    // 1/64 = 0.015625 per bit
    // 0.333333/0.015625 = 21.333312
    // 0.015625*21 = 0.328125 (close enough to 1/3)
    // 21 = 0b10101
    `define MULT 8'sb00_010101

    // the width of the result will be
    // the sum of the width of the two things
    // being multiplied. both of our numbers are
    // 8 bits so the result will be 16
    reg signed [15:0] mult_out;

    // calculate the new number every clock cycle
    always @(posedge clk, posedge rst) begin
        if (rst)
            mult_out <= 0;
        else if (en)
            mult_out <= in * `MULT;
    end

    // mult_out = 0000.000000_000000
    // we only want 8 bits from it
    assign out = mult_out[13:6];

endmodule
