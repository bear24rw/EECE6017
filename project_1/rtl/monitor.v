`include "constants.h"

module monitor(
    input clk,
    input rst,
    input en,

    input [3:0] temp_value_ones,
    input [3:0] temp_value_tens,
    input [3:0] temp_value_huns,
    input temp_value_sign,

    input [3:0] temp_value_ones_old,
    input [3:0] temp_value_tens_old,
    input [3:0] temp_value_huns_old,

    output [3:0] temp_delta_ones,
    output [3:0] temp_delta_tens,
    output [3:0] temp_delta_huns,
    output temp_delta_sign,

    output reg [1:0] state = `STATE_NORMAL
);

    initial state = `STATE_NORMAL;

    `define T5      12'h050
    `define T40     12'h400
    `define T47     12'h470
    `define T50     12'h500

    reg first_run = 1;

    reg [11:0] temp_delta_bcd = 0;
    reg [11:0] temp_value_bcd = 0;
    reg        temp_value_sign_old = 0;

    wire [3:0] current_delta_huns;
    wire [3:0] current_delta_tens;
    wire [3:0] current_delta_ones;
    wire       current_delta_sign;

    bcd_sub bs(
        .a_huns(temp_value_huns),
        .a_tens(temp_value_tens),
        .a_ones(temp_value_ones),

        .b_huns(temp_value_huns_old),
        .b_tens(temp_value_tens_old),
        .b_ones(temp_value_ones_old),

        .out_huns(temp_delta_huns),
        .out_tens(temp_delta_tens),
        .out_ones(temp_delta_ones),

        .negative(temp_delta_sign)
    );

    always @(temp_value_huns, temp_value_tens, temp_value_ones, rst) begin

        if (rst) begin
            first_run <= 1;
            state <= `STATE_NORMAL;
            temp_delta_bcd <= 0;
            temp_value_bcd <= 0;
        end 
        else if (en) begin


            temp_value_bcd <= {temp_value_huns, temp_value_tens, temp_value_ones};

            // if we are in an emergency state do not continue calculating new states
            // stay in the emergency state until the system is reset
            //if (state != `STATE_EMERGENCY) begin

                state = (temp_value_bcd <  `T40)                          ? `STATE_NORMAL :
                        (temp_value_bcd >= `T40 && temp_value_bcd < `T47) ? `STATE_BORDERLINE :
                        (temp_value_bcd >= `T47 && temp_value_bcd < `T50) ? `STATE_ATTENTION :
                        (temp_value_bcd >= `T50)                          ? `STATE_EMERGENCY :
                        0;//`STATE_EMERGENCY;


                if (!first_run) begin

                    // if the new temp is more than 5 away from current temp
                        /*
                    if (temp_delta_bcd > `T5)
                        state = `STATE_EMERGENCY;
                    */
                    
                    // if the mode changes during operation it's an emergency
                        /*
                    if (temp_value_sign != temp_value_sign_old)
                        state = `STATE_EMERGENCY;
                    */

                end else begin
                    first_run <= 0;
                end

            //end
        end

    end



endmodule
