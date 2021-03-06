/***************************************************************************
 *   Copyright (C) 2012 by Ian Cathey                                      *
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

module LFSR(clk, en, lfsr);

    input clk;
    input en;
    output reg [7:0] lfsr = 8'b10011011;

    // xor the special tap bits to generate the new lsb
    wire bit0;
    xnor(bit0, lfsr[7], lfsr[5], lfsr[4], lfsr[3]);

    // every clock generate the next number by
    // shifting in the result of the xor'd bits
    // we only want to generate new numbers
    // when enabled
    always @(posedge clk)
    begin
        if (en) lfsr <= {lfsr[6:0],bit0};
    end 
endmodule
