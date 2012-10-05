module counter_tb();

    reg clk = 0;
    reg en = 1;

    counter uut(
        .clk(clk),
        .en(en),
        .rst(rst)
    );

    always
        #1 clk = ~clk;

    initial begin
        $monitor("c: %0d bc: %0d | %0dE%0d", uut.count, uut.base_count, uut.base, uut.exponent);
    end

endmodule
