module div_3(
    input clk,
    input rst,
    input signed [7:0] in,
    output signed [7:0] out = 0
);

    // we want to multiply by (1/3)
    // we need to figure out what (1/3) is in binary
    // 6 fractional bits give 2**6 = 64 values
    // 1/64 = 0.015625 per bit
    // 0.3/0.015625 = 19.2
    // 0.3*19 = 0.296875 (close enough to 1/3)
    // 19 = 0b10011
    `define MULT 8'sb00_010011

    reg signed [15:0] mult_out;

    always @(posedge clk, posedge rst) begin
        if (rst)
            mult_out <= 0;
        else
            mult_out <= in * `MULT;
    end

    assign out = mult_out[

endmodule
