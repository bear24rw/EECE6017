module top (
    input clk, reset, w,
    output z
);

    wire a_q;
    wire b_q;
    wire c_q;
    wire d_q;
    wire e_q;
    wire f_q;
    wire g_q;
    wire h_q;
    wire i_q;

    assign a_d = reset;

    assign b_d = (~w) & (i_q | h_q | g_q | f_q | a_q) & (~b_q);
    assign f_d = (w) & (e_q | d_q | c_q | b_q | a_q) & (~f_q);
    
    assign c_d = b_q & (~w) & ~c_q;
    assign d_d = c_q & (~w) & ~d_q;
    assign e_d = (d_q & (~w)) | (e_q & ~w);
    
    assign g_d = f_q & w & ~g_q;
    assign h_d = g_q & w & ~h_q;
    assign i_d = (h_q & w) | (i_q & w);

    assign z = e_q | i_q;

    d_flop a(clk,     0, a_d, a_q);
    d_flop b(clk, reset, b_d, b_q);
    d_flop c(clk, reset, c_d, c_q);
    d_flop d(clk, reset, d_d, d_q);
    d_flop e(clk, reset, e_d, e_q);
    d_flop f(clk, reset, f_d, f_q);
    d_flop g(clk, reset, g_d, g_q);
    d_flop h(clk, reset, h_d, h_q);
    d_flop i(clk, reset, i_d, i_q);

endmodule
