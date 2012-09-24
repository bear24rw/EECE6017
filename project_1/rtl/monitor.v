`include "constants.h"

module monitor(
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

    output [1:0] state
);

    // express the thresholds in hex because it is the same
    // as 3 bcd digits catted together
    `define T5      12'h050
    `define T40     12'h400
    `define T47     12'h470
    `define T50     12'h500

    // cat the bcd digits together so we can do easy comparisons
    wire [11:0] temp_value_bcd = {temp_value_huns, temp_value_tens, temp_value_ones};
    wire [11:0] temp_delta_bcd = {temp_delta_huns, temp_delta_tens, temp_delta_ones};

    // we need at least two values before our delta is valid
    // this register counts up to tell when we have 2 values
    reg [1:0] two_values = 0;

    // the 'en' line going high is our trigger that the system
    // received a new value
    always @(posedge en, posedge rst) begin
        if (rst) begin
            two_values = 0;
        end else begin
            // have we received two values yet?
            if (two_values < 2)
                two_values = two_values + 1;
        end
    end


    // since we don't have dual edge flops we have to use two single edge
    reg mode_changed_pos = 0;
    reg mode_changed_neg = 0;

    always @(posedge temp_value_sign, posedge rst)
        if (rst) mode_changed_pos = 0;
        else mode_changed_pos = 1;

    always @(negedge temp_value_sign, posedge rst)
        if (rst) mode_changed_neg = 0;
        else mode_changed_neg = 1;

    assign mode_changed = mode_changed_neg | mode_changed_pos;


    // priority mux to determine what state we're in
    assign state = 
        (two_values == 2 && en && mode_changed)             ? `STATE_EMERGENCY :
        (two_values == 2 && en && temp_delta_bcd > `T5)     ? `STATE_EMERGENCY :
        (temp_value_bcd <  `T40)                            ? `STATE_NORMAL :
        (temp_value_bcd >= `T40 && temp_value_bcd < `T47)   ? `STATE_BORDERLINE :
        (temp_value_bcd >= `T47 && temp_value_bcd < `T50)   ? `STATE_ATTENTION :
        (temp_value_bcd >= `T50)                            ? `STATE_EMERGENCY :
        0;//`STATE_EMERGENCY;

endmodule
