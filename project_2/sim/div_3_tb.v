module div_3_tb();

    reg clk = 0;
    reg rst = 0;
    reg en = 1;
    reg signed [7:0] in = 0;

    wire signed [7:0] out;

    div_3 uut(
        .clk(clk),
        .rst(rst),
        .en(en),
        .in(in),
        .out(out)
    );

    `define NUM_VALUES  1000
    reg signed [7:0] test_values [0:`NUM_VALUES-1];
    initial $readmemh("../sim/random.txt", test_values);

    integer i;

    initial begin

        #10 rst = 1; #10 rst = 0;

        for (i = 0; i < `NUM_VALUES; i=i+1) begin

            in = test_values[i];

            // pulse the clock
            #1 clk = 1; #1 clk = 0;

            // can't display leading zeros
            // pipe sim output through sed 's/\. \+/\.0/g'
            disp_num(in);
            $write("|");
            disp_num(out);
            $write("\n");

       end

       $finish;

    end


    reg [7:0] z = 0;

    task disp_num;
        input signed [7:0] x;
        begin
            // check if negative
            if (x[7]) begin
                z = (~(x[7:0]))+1;
                $write("-");
                $write("%0d.%6d", z[7:6], z[5:0]*15625);
            end else begin
                $write("%0d.%6d", x[7:6], x[5:0]*15625);
            end
        end
    endtask

endmodule
