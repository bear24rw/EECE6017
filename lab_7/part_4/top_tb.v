`timescale 1ns / 100ps

module top_tb;

    // letter indexes
    parameter A = 4'b0000;
    parameter B = 4'b0001;
    parameter C = 4'b0010;
    parameter D = 4'b0011;
    parameter E = 4'b0100;
    parameter F = 4'b0101;
    parameter G = 4'b0110;
    parameter H = 4'b0111;

    // inputs
    reg clk;
    reg reset;
    reg xmit;
    reg [3:0] letter;

    // outputs
    wire led;

    // instantiate the mores code module
    top uut(
        .clk(clk),
        .reset(reset),
        .letter(letter),
        .xmit(xmit),
        .led(led)
    );

    // continuous clock
    // we do not care about actual frequency for simulation
    always
        #1 clk = ~clk;

    // function to toggle the xmit line
    task pulse_xmit;
        begin
            xmit = 1;
            #2 xmit = 0;
        end
    endtask

    // run through all the tests
    initial begin

        // reset inputs
        clk = 0;
        xmit = 0;

        // pulse the reset line
        reset = 1;
        #50;
        reset = 0;
        #50

        // run through all the letters
        letter = A;
        pulse_xmit;
        #50;

        letter = B;
        pulse_xmit;
        #50;

        letter = C;
        pulse_xmit;
        #50;

        letter = D;
        pulse_xmit;
        #50;

        letter = E;
        pulse_xmit;
        #50;

        letter = F;
        pulse_xmit;
        #50;

        letter = G;
        pulse_xmit;
        #50;

        letter = H;
        pulse_xmit;
        #50;

        $stop;
    end

endmodule
