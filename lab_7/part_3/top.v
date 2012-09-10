module top (
    input clk, reset, w,
    output z
);

    wire [3:0] one_detect;
    wire [3:0] zero_detect;

    bit_shift_4 ic1(
        .clk(clk),
        .d(w),
        .q(one_detect)
    );

    bit_shift_4 ic2(
        .clk(clk),
        .d(w),
        .q(zero_detect)
    );

    assign z = (one_detect == 4'b1111) || (zero_detect == 4'b0000);

    /* using just one shift register

    wire detect;

    4_bit_shift ic2(
        .clk(clk),
        .d(w),
        .q(detect)
    );

    assign z = (detect == 4'b1111) || (_detect == 4'b0000);

    */

endmodule
