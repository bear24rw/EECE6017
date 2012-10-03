module sum_3_tb();

    reg clk = 0;
    reg rst = 0;
    reg [7:0] in = 0;

    wire signed [7:0] out;

    sum_3 uut(
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );

    `define NUM_VALUES  1000
    reg [7:0] test_values [0:`NUM_VALUES-1];
    initial $readmemh("../sim/random.txt", test_values);

    integer i;

    initial begin

        #10 rst = 1; #10 rst = 0;

        for (i = 0; i < `NUM_VALUES; i=i+1) begin

            in = test_values[i];

            // pulse the clock
            #1 clk = 1; #1 clk = 0;

            $display("%0d+%0d+%0d=%0d",
                uut.value_0,
                uut.value_1,
                uut.value_2,
                out,
            );
            
        end

        $finish;

    end

endmodule
