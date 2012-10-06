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

`include "constants.h"

module counter(
    input clk,
    input rst,
    input en,
    output reg [6:0] o_base = 0,
    output reg [3:0] o_exponent = 0
);

    reg [6:0] base = 0;
    reg [3:0] exponent = 0;
    reg [29:0] count = 0;

    always @(posedge clk, posedge rst) begin

        // if we are in reset we want to clear everything inluding
        // the output values
        if (rst) begin
            base = 0;
            exponent = 0;
            count = 0;
            o_base = 0;
            o_exponent = 0;

        // if we are not enabled we also want to reset everything
        // we still want to keep the output values because we want 
        // to be able to read them when system is stopped
        end else if (!en) begin
            base = 0;
            exponent = 0;
            count = 0;

        // normal operation, just count up
        end else begin

            count = count + 1;

            case (exponent)
                0: if (count == 10**00) begin base = base + 1; count = 0; end
                1: if (count == 10**01) begin base = base + 1; count = 0; end
                2: if (count == 10**02) begin base = base + 1; count = 0; end
                3: if (count == 10**03) begin base = base + 1; count = 0; end
                4: if (count == 10**04) begin base = base + 1; count = 0; end
                5: if (count == 10**05) begin base = base + 1; count = 0; end
                6: if (count == 10**06) begin base = base + 1; count = 0; end
                7: if (count == 10**07) begin base = base + 1; count = 0; end
                8: if (count == 10**08) begin base = base + 1; count = 0; end
                9: if (count == 10**09) begin base = base + 1; count = 0; end
            endcase                      

            if (base == 100) begin 
                base = 10; 
                exponent = exponent + 1; 
            end

            o_base = base;
            o_exponent = exponent;
        end
    end

endmodule
