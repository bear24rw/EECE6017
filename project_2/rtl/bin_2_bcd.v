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

module bin_2_bcd (
    input [7:0] bin,
    output reg [3:0] tens,
    output reg [3:0] ones
);

    reg [3:0] num_shifts = 0;
    reg [7:0] binary = 0;

    always @(*) begin

        num_shifts = 0;
        tens = 0;
        ones = 0;

        binary = bin;

        while (num_shifts < 8) begin
            
            if (tens >= 5)
                tens = tens + 3;
            if (ones >= 5)
                ones = ones + 3;

            tens = tens << 1;
            tens[0] = ones[3];

            ones = ones << 1;
            ones[0] = binary[7];

            binary = binary << 1;

            num_shifts = num_shifts + 1;

        end
    end

endmodule
