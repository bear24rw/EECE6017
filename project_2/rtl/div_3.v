module div_3(
    input clk,
    input rst,
    input en,
    input signed [7:0] in,
    output signed [7:0] out
);

    // we want to multiply by (1/3)
    // we need to figure out what (1/3) is in binary
    // 6 fractional bits give 2**6 = 64 values
    // 1/64 = 0.015625 per bit
    // 0.333333/0.015625 = 21.333312
    // 0.015625*21 = 0.328125 (close enough to 1/3)
    // 21 = 0b10101
    `define MULT 8'sb00_010101

    reg signed [15:0] mult_out;

    always @(posedge clk, posedge rst) begin
        if (rst)
            mult_out <= 0;
        else if (en)
            mult_out <= in * `MULT;
    end

    // mult_out = 0000.000000_000000
    // we only want 8 bits from it
    assign out = mult_out[13:6];

endmodule
