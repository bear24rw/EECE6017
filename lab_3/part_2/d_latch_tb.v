`timescale 1ns / 100ps

module d_latch_tb;

    // inputs to the latch
    reg clk;
    reg d;

    // output from the latch
    wire q;

    // instantiate a d_latch
    d_latch uut(
        .clk(clk),
        .d(d),
        .q(q)
    );

    // 1/(1us) clock
    always
        #1 clk = ~clk;

    initial begin

        // reset inputs
        clk = 0;
        d = 0;

        // results table
        $display("d  |  q");
        $display("-------");
        $monitor("%d  |  %d", d, q);

        // run through different latch inputs on each clock cycle
        @(negedge clk)
            d = 0;

        @(negedge clk)
            d = 1;

        @(negedge clk)
            d = 0;

        // stop the simulation
        @(negedge clk)
            $stop;

    end

endmodule
