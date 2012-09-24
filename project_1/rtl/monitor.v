`include "constants.h"

module monitor(
    input clk,
    input rst,
    input en,

    input [3:0] temp_value_ones,
    input [3:0] temp_value_tens,
    input [3:0] temp_value_huns,
    input temp_value_sign,

    input [3:0] temp_delta_ones,
    input [3:0] temp_delta_tens,
    input [3:0] temp_delta_huns,
    input temp_delta_sign,

    output reg [1:0] state = `STATE_NORMAL
);

    `define T5      12'h050
    `define T40     12'h400
    `define T47     12'h470
    `define T50     12'h500

    reg first_run = 1;

    reg [11:0] temp_value_bcd = 0;
    reg temp_value_sign_old = 0;

    wire [11:0] temp_delta_bcd = {temp_delta_huns, temp_delta_tens, temp_delta_ones};


    always @(temp_value_huns, temp_value_tens, temp_value_ones, rst) begin

        if (rst) begin
            first_run = 1;
            state = `STATE_NORMAL;
        end 
        else if (en) begin

            // concatenate the bcd values so it's easy to compare
            temp_value_bcd = {temp_value_huns, temp_value_tens, temp_value_ones};

            // figure out what state we are in
            state = (temp_value_bcd <  `T40)                          ? `STATE_NORMAL :
                    (temp_value_bcd >= `T40 && temp_value_bcd < `T47) ? `STATE_BORDERLINE :
                    (temp_value_bcd >= `T47 && temp_value_bcd < `T50) ? `STATE_ATTENTION :
                    (temp_value_bcd >= `T50)                          ? `STATE_EMERGENCY :
                    0;//`STATE_EMERGENCY;


            // if this is the first run we don't want to error
            // on a temp difference or sign change
            if (!first_run) begin

                // if the new temp is more than 5 away from 
                if (temp_delta_bcd > `T5)
                    state = `STATE_EMERGENCY;
                
                // if the mode changes during operation it's an emergency
                if (temp_value_sign != temp_value_sign_old)
                    state = `STATE_EMERGENCY;

            end else begin
                first_run <= 0;
            end

        end

    end


endmodule
