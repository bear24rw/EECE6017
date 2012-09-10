module bit_shift_4(
    input clk, d,
    output reg [3:0] q = 4'bxxxx
);

    always @(posedge clk) begin
        q <= q << 1;
        q[0] <= d;
    end

endmodule
