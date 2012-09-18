module monitor(
    input clk,
    input mode,
    input [5:0] temp,
    input [3:0] temp_frac,
    output reg [3:0] state
);

    parameter STATE_NORMAL      = 0;
    parameter STATE_BORDERLINE  = 1;
    parameter STATE_ATTENTION   = 2;
    parameter STATE_EMERGENCY   = 3;

    reg old_mode = 0;
    reg [9:0] temp_comb;
    reg [9:0] old_temp_comb;

    always @(posedge clk) begin
        temp_comb = (temp << 4) | temp_frac;

        if (temp_comb < (40 << 4)) state = STATE_NORMAL;
        if ((temp_comb >= (40 << 4)) && (temp_comb < (47 << 4))) state = STATE_BORDERLINE;
        if ((temp_comb >= (47 << 4)) && (temp_comb < (50 << 4))) state = STATE_ATTENTION;
        if (temp_comb >= (50 << 4)) state = STATE_EMERGENCY;

        if (mode != old_mode) state = STATE_EMERGENCY;
        
        if (temp_comb > old_temp_comb)
            if (temp_comb - old_temp_comb > (5 << 4)) state = STATE_EMERGENCY;
        else
            if (old_temp_comb - temp_comb > (5 << 4)) state = STATE_EMERGENCY;

        old_temp_comb = temp_comb;
        old_mode = mode;
    end

endmodule
