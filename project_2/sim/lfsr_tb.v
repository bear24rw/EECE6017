module lfsr_tb();

    reg clk = 0;
    reg en = 1;
    wire [7:0] value;

    LFSR uut(clk, en, value);

    always
        #1 clk = ~clk;

    initial begin
        $monitor("%d", value);
        #100000;
        $finish;
    end

endmodule
