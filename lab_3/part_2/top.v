module top (
    input SW_0, SW_1,
    output reg LED_R0
);

    d_latch d_latch(
        .clk(SW_1),
        .d(SW_0),
        .q(LED_R0)
    );

endmodule
