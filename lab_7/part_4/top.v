/***************************************************************************
 *   Copyright (C) 2012 by Max Thrun                                       *
 *   bear24rw@gmail.com                                                    *
 *                                                                         *
 *   Lab 7 Part 4                                                          *
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

module top (
    input clk, reset, send,
    input [3:0] letter,
    output reg led
);


    // FSM states
    parameter STATE_IDLE = 0;
    parameter STATE_DOT = 1;
    parameter STATE_DASH_1 = 2;
    parameter STATE_DASH_2 = 3;
    parameter STATE_DASH_3 = 4;

    reg [3:0] next_state;               // next state of the FSM
    reg [3:0] cur_state = STATE_IDLE;   // current state of the FSM

    // letter indexes
    parameter A = 4'b0000;
    parameter B = 4'b0001;
    parameter C = 4'b0010;
    parameter D = 4'b0011;
    parameter E = 4'b0100;
    parameter F = 4'b0101;
    parameter G = 4'b0110;
    parameter H = 4'b0111;

    // which bit of the letter code we are currently sending
    // initialize as 4 because we aren't sending anything intially
    reg [3:0] bit_pos = 4;

    // morse code lookup table
    // each code is 4 bits
    // letters A -> H
    reg [3:0] codes [7:0];

    // 1 = dot
    // 0 = dash
    // z = nothing (just used for padding)
    // bits are reversed
    initial begin
        codes[A] <= 4'bzz01; // .-
        codes[B] <= 4'b1110; // -...
        codes[C] <= 4'b1010; // -.-.
        codes[D] <= 4'bz110; // _..
        codes[E] <= 4'bzzz1; // .
        codes[F] <= 4'b1011; // ..-.
        codes[G] <= 4'bz100; // --.
        codes[H] <= 4'b1111; // ....
    end

    // FSM state table
    always @(cur_state, send)
    begin: state_table

        // jump to the current state
        case (cur_state)

            // dot is just high for a single clock cyle
            STATE_DOT: begin
                led <= 1;
                next_state <= STATE_IDLE;
            end

            // dash is high for 3 clock cycles
            STATE_DASH_1: begin
                led <= 1;
                next_state <= STATE_DASH_2;
            end

            STATE_DASH_2:
                next_state <= STATE_DASH_3;

            STATE_DASH_3:
                next_state <= STATE_IDLE;

            STATE_IDLE: begin
                led <= 0;

                // if restarting start at the LSB
                if (send) bit_pos = 0;

                // if we haven't finished sending all the bits
                if (bit_pos < 4) begin

                    // lookup if this bit is a dash or a dot
                    // if it is 'z' then just stay in this state
                    case (codes[letter][bit_pos])
                        1'b1: next_state <= STATE_DOT;
                        1'b0: next_state <= STATE_DASH_1;
                        default: next_state <= STATE_IDLE;
                    endcase

                    // we just handled that bit so go to the next one
                    bit_pos = bit_pos + 1'b0001;
                end
            end

            // we should never get here but if we do go to the 'safe' idle state
            default:
                next_state = STATE_IDLE;

        endcase
    end

    // steps or resets the state machine
    always @(posedge clk)
    begin: state_FFs
        if (reset)
            cur_state <= STATE_IDLE;
        else
            cur_state <= next_state;
    end

endmodule
