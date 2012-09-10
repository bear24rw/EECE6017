module d_flop(
    input clk, d,
    output reg q
);

    always @(posedge clk)
        q = d;

endmodule
