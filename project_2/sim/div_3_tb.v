module div_3_tb();

    reg clk = 0;
    reg rst = 0;
    reg signed [7:0] in = 0;

    wire signed [7:0] out;

    div_3 uut(
        .clk(clk),
        .rst(rst),
        .in(in),
        .out(out)
    );

    `define NUM_VALUES  1000
    reg signed [7:0] test_values [0:`NUM_VALUES-1];
    initial $readmemh("../sim/random.txt", test_values);

    integer i;

    reg [19:0] in_frac;
    reg [19:0] out_frac;

    reg signed [1:0] in_int;
    reg signed [1:0] out_int;

    initial begin

        #10 rst = 1; #10 rst = 0;

        for (i = 0; i < `NUM_VALUES; i=i+1) begin

            in = test_values[i];

            // pulse the clock
            #1 clk = 1; #1 clk = 0;

            in_int = in[7:6];
            out_int = out[7:6];

            in_frac = in[5:0] * 15625;
            out_frac = out[5:0] * 15625;

            $display("[%b] %0d.%0d = %0d.%0d [%b]",
                in,
                in_int,
                in_frac,
                out_int,
                out_frac,
                out
            );
            
        end

        $finish;

    end

endmodule
