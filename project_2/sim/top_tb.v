/***************************************************************************
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

module top_tb();
    
    reg CLOCK_50 = 0;
    reg [3:0] KEY = 4'b1111;
    reg [9:0] SW;
    wire [7:0] LEDG;
    wire [9:0] LEDR;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
        
        
    top uut(
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .LEDG(LEDG),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );
    
        
    integer i;
        
    initial begin

        // reset the system
        reset;
        
        // Start the random number generator
        #100 start_stop;
        
        for (i=0; i<1000; i = i+1) begin
            #1 CLOCK_50 = 1;
            #1 CLOCK_50 = 0;

            $write("%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d",
                uut.rand_value,
                uut.div_value,
                uut.sum_value,
                uut.base,
                uut.exponent,
                uut.base_bcd_ones,
                uut.base_bcd_tens,
                uut.exponent_bcd,
                uut.sum.value_0,
                uut.sum.value_1,
                uut.sum.value_2,
            );
        end
        
        // stop the generator and the test
        #100 start_stop;
        
        #1000;
        $finish;

    end
            
            
    // pulses the reset key
    task reset; begin
        #50 KEY[0] = 0; #50 KEY[0] = 1;
    end
    endtask


    // pulses the start/stop key
    task start_stop; begin
        #50 KEY[3] = 0; #50 KEY[3] = 1;
    end
    endtask 
        
endmodule
