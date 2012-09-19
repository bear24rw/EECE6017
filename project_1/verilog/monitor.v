module monitor(
    input clk,
    input rst,
    input mode,
    input [5:0] temp,
    input [3:0] temp_frac,
    output reg temp_delta_sign,
    output reg [5:0] temp_delta,
    output reg [3:0] temp_delta_frac,
    output reg [3:0] state
);

    parameter STATE_NORMAL      = 0;
    parameter STATE_BORDERLINE  = 1;
    parameter STATE_ATTENTION   = 2;
    parameter STATE_EMERGENCY   = 3;

    reg old_mode = 0;
    reg first_run = 1;
    reg [9:0] temp_comb;
    reg [9:0] old_temp_comb;
    reg [9:0] temp_comb_delta;

    always @(posedge clk, posedge rst) begin

        if (rst) begin
            first_run = 1;
            temp_delta = 0;
            temp_delta_frac = 0;
            temp_delta_sign = 0;
            old_temp_comb = 0;
            state = STATE_NORMAL;
        end else begin

            // if we are in an emergency state do not continue calculating new states
            // stay in the emergency state until the system is reset
            if (state != STATE_EMERGENCY) begin
                temp_comb = (temp << 4) | temp_frac;

                if (temp_comb < (40 << 4)) state = STATE_NORMAL;
                if ((temp_comb >= (40 << 4)) && (temp_comb < (47 << 4))) state = STATE_BORDERLINE;
                if ((temp_comb >= (47 << 4)) && (temp_comb < (50 << 4))) state = STATE_ATTENTION;
                if (temp_comb >= (50 << 4)) state = STATE_EMERGENCY;

                // compute the change in temp from the last reading
                if (temp_comb > old_temp_comb) begin
                    temp_comb_delta = temp_comb - old_temp_comb;
                    temp_delta_sign = 0;
                end else begin
                    temp_comb_delta = old_temp_comb - temp_comb;
                    temp_delta_sign = 1;
                end

                if (first_run == 0) begin
                    // if the new temp is more than 5 away from current temp
                    if (temp_comb_delta > (5 << 4)) state = STATE_EMERGENCY;

                    // if the mode changes during operation it's an emergency
                    if (mode != old_mode) state = STATE_EMERGENCY;
                end else begin
                    first_run = 0;
                end

                // split temp delta into units and fraction
                temp_delta = temp_comb_delta[9:4];
                temp_delta_frac = temp_comb_delta[3:0];

                // current temp is now the old temp
                old_temp_comb = temp_comb;
                old_mode = mode;
            end
        end

    end

endmodule
