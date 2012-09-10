module top (
    input SW_0, SW_1,
    output LED_R0
);

    wire q_m;

    d_latch master(
        .clk(~SW_1),
        .d(SW_0),
        .q(q_m)
    );

    d_latch slave(
        .clk(SW_1),
        .d(q_m),
        .q(LED_R0)
    );

endmodule
