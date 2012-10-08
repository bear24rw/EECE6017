/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
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
module counter_tb();

    reg clk = 0;
    reg en = 1;

    counter uut(
        .clk(clk),
        .en(en),
        .rst(rst)
    );

    always
        #1 clk = ~clk;

    initial begin
        $monitor("c: %0d bc: %0d | %0dE%0d", uut.count, uut.base_count, uut.base, uut.exponent);
    end

endmodule
