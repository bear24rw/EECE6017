/***************************************************************************
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

module sum_3_tb();

    reg clk = 0;
    reg rst = 0;
    reg en = 1;
    reg [7:0] in = 0;

    wire signed [7:0] out;

    sum_3 uut(
        .clk(clk),
        .rst(rst),
        .en(en),
        .in(in),
        .out(out)
    );

    `define NUM_VALUES  1000
    reg [7:0] test_values [0:`NUM_VALUES-1];
    initial $readmemh("../sim/random.txt", test_values);

    integer i;

    initial begin

        #10 rst = 1; #10 rst = 0;

        for (i = 0; i < `NUM_VALUES; i=i+1) begin

            in = test_values[i];

            // pulse the clock
            #1 clk = 1; #1 clk = 0;

            $display("%0d+%0d+%0d=%0d",
                uut.value_0,
                uut.value_1,
                uut.value_2,
                out,
            );
            
        end

        $finish;

    end

endmodule
