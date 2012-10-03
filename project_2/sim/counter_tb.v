module counter_tb();

    reg clk = 0;

    counter uut(
        .clk(clk),
        .rst(rst)
    );

    always
        #1 clk = ~clk;

    initial begin
        $monitor("c: %0d bc: %0d | %0dE%0d", uut.count, uut.base_count, uut.base, uut.exponent);
    end

endmodule
