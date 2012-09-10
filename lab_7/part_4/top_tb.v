`timescale 1ns / 100ps

module top_tb;

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
    reg [3:0] letter;
    reg send;

    // outputs
    wire led;

    // instantiate the top level d flip flop
    top uut(
        .clk(clk),
        .reset(reset),
        .letter(letter),
        .send(send),
        .led(led)
    );

    always
        #1 clk = ~clk;

    initial begin

        // reset inputs
        clk = 0;
        send = 0;

        reset = 1;
        #50;
        reset = 0;
        #50

        letter = A;
        send = 1; #2 send = 0;
        #50;

        letter = B;
        send = 1; #2 send = 0;
        #50;

        letter = C;
        send = 1; #2 send = 0;
        #50;

        letter = D;
        send = 1; #2 send = 0;
        #50;

        letter = E;
        send = 1; #2 send = 0;
        #50;

        letter = F;
        send = 1; #2 send = 0;
        #50;

        letter = G;
        send = 1; #2 send = 0;
        #50;

        letter = H;
        send = 1; #2 send = 0;
        #50;

        $stop;

    end

endmodule
