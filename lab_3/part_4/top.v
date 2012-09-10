module top (
    input clk, d,
    output qa, qb, qc
);

    // gated latch
    d_latch d_latch(
        .clk(clk),
        .d(d),
        .q(qa)
    );

    // positive-edge triggered d flip-flop
     d_flop d_flop(
        .clk(clk),
        .d(d),
        .q(qb)
    );

    // negative-edge triggered d flip_flop
    d_flop neg_d_flop(
        .clk(~clk),
        .d(d),
        .q(qc)
    );

endmodule
