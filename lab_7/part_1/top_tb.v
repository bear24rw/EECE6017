`timescale 1ns / 100ps

module top_tb;

    // inputs
    reg clk;
    reg reset;
    reg w;

    // outputs
    wire z;

    // instantiate the top level d flip flop
    top uut(
        .clk(clk),
        .reset(reset),
        .w(w),
        .z(z)
    );

    always
        #5 clk = ~clk;

    always @(posedge clk)
        if (~reset)
            $display("%d | %d", w, z);

    initial begin
        // results table
        $display("w | z");
        $display("--------");

        // reset inputs
        clk = 0;
        w = 0;

        reset = 1;
        #100;
        reset = 0;

        // wave form as described by Figure 1
        #20 w = 1;
        #10 w = 0;
        #40 w = 1;
        #50 w = 0;

        #100;

        // stop the simulation
        @(negedge clk)
            $stop;

    end

endmodule
