module d_latch (
    input clk, d,
    output reg q
);

    always @ (d, clk)
        if (clk)
            q = d;

endmodule
