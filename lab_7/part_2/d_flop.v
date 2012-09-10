module d_flop(
    input clk, clr, d,
    output reg q = 0
);

    always @(posedge clk)
        if (clr) begin
            q <= 0;
        end else begin
            q <= d;
        end

endmodule
