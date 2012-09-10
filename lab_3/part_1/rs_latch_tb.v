`timescale 1ns / 100ps

module rs_latch_tb;

    // inputs to the latch
    reg clk;
    reg r;
    reg s;

    // output from the latch
    wire q;

    // instantiate a rs_latch
    rs_latch uut(
        .Clk(clk),
        .R(r),
        .S(s),
        .Q(q)
    );

    // 1/(1us) clock
    always
        #1 clk = ~clk;

    initial begin

        // reset inputs
        clk = 0;
        r = 0;
        s = 0;

        // heading for our table
        $display("r  s  |  q");
        $display("----------");
        $monitor("%d  %d  |  %d", r, s, q);

        // run through different latch inputs on each clock cycle
        @(negedge clk) begin
            r <= 0;
            s <= 0;
        end

        @(negedge clk) begin
            r <= 0;
            s <= 1;
        end

        @(negedge clk) begin
            r <= 1;
            s <= 0;
        end

        @(negedge clk) begin
            r <= 0;
            s <= 0;
        end

        // stop the simulation
        @(negedge clk)
            $stop;

    end

endmodule
