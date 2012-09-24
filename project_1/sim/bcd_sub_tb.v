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

`timescale 1us / 100ps

module bcd_sub_tb();

    reg [3:0] a_ones;
    reg [3:0] a_tens;
    reg [3:0] a_huns;

    reg [3:0] b_ones;
    reg [3:0] b_tens;
    reg [3:0] b_huns;
    
    wire [3:0] out_ones;
    wire [3:0] out_tens;
    wire [3:0] out_huns;

    wire negative;

    bcd_sub uut(
        .a_ones(a_ones),
        .a_tens(a_tens),
        .a_huns(a_huns),

        .b_ones(b_ones),
        .b_tens(b_tens),
        .b_huns(b_huns),

        .out_ones(out_ones),
        .out_tens(out_tens),
        .out_huns(out_huns),

        .negative(negative)
    );
    
    initial begin
        $dumpfile("bcd_sub_tb.vcd");
        $dumpvars(0, bcd_sub_tb);
    end

    initial begin

        for (a_huns = 0; a_huns < 10; a_huns=a_huns+1)
        for (a_tens = 0; a_tens < 10; a_tens=a_tens+1)
        for (a_ones = 0; a_ones < 10; a_ones=a_ones+1)
        for (b_huns = 0; b_huns < 10; b_huns=b_huns+1)
        for (b_tens = 0; b_tens < 10; b_tens=b_tens+1)
        for (b_ones = 0; b_ones < 10; b_ones=b_ones+1)
        begin

            #10;
            $write("%d%d%d - %d%d%d = ", a_huns, a_tens, a_ones, b_huns, b_tens, b_ones);
            if (negative) $write("-");
            $write("%d%d%d\n", out_huns, out_tens, out_ones);
        end
        $stop;

    end

endmodule


