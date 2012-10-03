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

module sum_3(
    input clk,
    input rst,
    input signed [7:0] in,
    output signed [7:0] out
);

    reg signed [7:0] value_0 = 0;
    reg signed [7:0] value_1 = 0;
    reg signed [7:0] value_2 = 0;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            value_0 <= 0;
            value_1 <= 0;
            value_2 <= 0;
        end else begin
            value_2 <= value_1;
            value_1 <= value_0;
            value_0 <= in;
        end
    end

    assign out = value_0 + value_1 + value_2;

endmodule

