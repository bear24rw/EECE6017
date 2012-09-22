`include "constants.h"

module monitor(
    input clk,
    input rst,
    input en,
    input mode,

    input [3:0] temp_value_ones,
    input [3:0] temp_value_tens,
    input [3:0] temp_value_huns,
    output reg temp_value_sign,

    output [3:0] temp_delta_ones,
    output [3:0] temp_delta_tens,
    output [3:0] temp_delta_huns,
    output  temp_delta_sign,

    output reg [3:0] state
);

    `define T5      12'h050
    `define T40     12'h400
    `define T47     12'h470
    `define T50     12'h500

    reg first_run = 1;

    wire [11:0] temp_value_bcd;
    wire [11:0] temp_delta_bcd;
    assign temp_value_bcd ={temp_value_huns, temp_value_tens, temp_value_ones};
    assign temp_delta_bcd = {temp_delta_huns, temp_delta_tens, temp_delta_ones};

    reg [3:0] temp_value_huns_old = 0;
    reg [3:0] temp_value_tens_old = 0;
    reg [3:0] temp_value_ones_old = 0;
    reg       temp_value_sign_old = 0;

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

    initial temp_value_sign = 0;
    always @(posedge mode)
        temp_value_sign = ~temp_value_sign;

    always @(posedge clk, posedge rst) begin

        if (rst) begin
            first_run = 1;
            state = `STATE_NORMAL;
        end 
        else if (en) begin

            // if we are in an emergency state do not continue calculating new states
            // stay in the emergency state until the system is reset
            if (state != `STATE_EMERGENCY) begin

                state = (temp_value_bcd <  `T40)                          ? `STATE_NORMAL :
                        (temp_value_bcd >= `T40 && temp_value_bcd < `T47) ? `STATE_BORDERLINE :
                        (temp_value_bcd >= `T47 && temp_value_bcd < `T50) ? `STATE_ATTENTION :
                        (temp_value_bcd >= `T50)                          ? `STATE_EMERGENCY :
                        `STATE_EMERGENCY;


                if (!first_run) begin

                    // if the new temp is more than 5 away from current temp
                    if (temp_delta_bcd > `T5)
                        state = `STATE_EMERGENCY;
                    
                    // if the mode changes during operation it's an emergency
                    if (temp_value_sign != temp_value_sign_old)
                        state = `STATE_EMERGENCY;

                end else begin
                    first_run = 0;
                end

                // current temp is now the old temp
                temp_value_huns_old = temp_value_huns;
                temp_value_tens_old = temp_value_tens;
                temp_value_ones_old = temp_value_ones;
                temp_value_sign_old = temp_value_sign;
            end
        end

    end

endmodule
