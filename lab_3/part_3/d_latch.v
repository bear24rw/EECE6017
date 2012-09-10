module d_latch (
    input clk, d,
    output q
    );

    wire r, s_g, r_g /* synthesis keep */ ;

    not (r, d);
    nand (s_g, d, clk);
    nand (r_g, r, clk);
    nand (qa, s_g, qb);
    nand (qb, r_g, qa);

    assign q = qa;

endmodule
