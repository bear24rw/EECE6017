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

module pulse_led(
    input clk,
    output reg led = 0
);

    // simple pwm pulsing

    // 'counter' just keeps counting up to PERIOD.
    // if 'counter' is greater than 'compare' the
    // led gets either turned on or off depending on 
    // which direction we are pulsing.
    // every time 'counter' reaches PERIOD 'compare'
    // is increased by STEP_SIZE.
    // we are essentially sweeping the duty cycle 
    // from 0% to 100% by (step_size/period)%

    parameter period    = 500000;
    parameter step_size = 20000;

    reg [28:0] counter = 0;
    reg [28:0] compare = 0;
    reg dir = 0;

    always @(posedge clk) begin
        counter = counter + 1;

        if (counter < compare)
            led = dir ? 1 : 0;
        else
            led = dir ? 0 : 1;

        if (counter == period) begin
            counter = 0;

            compare = compare + step_size;
            if (compare > period) begin
                compare = 0;
                dir = ~dir;
            end
        end
    end

endmodule

