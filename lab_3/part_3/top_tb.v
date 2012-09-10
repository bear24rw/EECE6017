`timescale 1ns / 100ps

module top_tb;

    // inputs to the d flip flop
    reg clk;
    reg d;

    // output from the d flip flop
    wire q;

    // instantiate the top level d flip flop
    top uut(
        .SW_0(d),
        .SW_1(clk),
        .LED_R0(q)
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
