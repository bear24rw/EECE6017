`timescale 1ns / 100ps

module top_tb;

    // inputs
    reg clk;
    reg d;

    // outputs
    wire qa;
    wire qb;
    wire qc;

    // instantiate the top level d flip flop
    top uut(
        .clk(clk),
        .d(d),
        .qa(qa),
        .qb(qb),
        .qc(qc)
    );

    initial begin

        // reset inputs
        clk = 0;
        d = 0;

        // results table
        $display("d  |  qa  qb  qc");
        $display("----------------");
        $monitor("%d  |  %d  %d  %d", d, qa, qb, qc);

        // wave form as described by Figure 6b
        #1; d = 1;
        #1; clk = 1;
        #1 d = 0;
        #1; d = 1;
        #2; d = 0;
        #2; clk = 0;
        #1; d = 1;
        #2; d = 0;
        #1; d = 1;
        #1; d = 0;
        #1; clk = 1;
        #1; d = 1;
        #1; d = 0;
        #1; d = 1;
        #2; clk = 0;
        #1; d = 0;

        #10;

        // stop the simulation
        @(negedge clk)
            $stop;

    end

endmodule
