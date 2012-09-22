module bin_2_bcd_tb();

    reg [11:0] bin;
    wire [3:0] huns;
    wire [3:0] tens;
    wire [3:0] ones;

    bin_2_bcd uut(
        .bin(bin),
        .huns(huns),
        .tens(tens),
        .ones(ones)
    );

    reg [11:0] a;
    reg [11:0] b;

    reg [3:0] b_ones;
    reg [3:0] b_tens;
    reg [3:0] b_huns;

    reg [3:0] a_ones;
    reg [3:0] a_tens;
    reg [3:0] a_huns;

    initial begin
/*
        for (a_huns = 0; a_huns < 10; a_huns=a_huns+1)
        for (a_tens = 0; a_tens < 10; a_tens=a_tens+1)
        for (a_ones = 0; a_ones < 10; a_ones=a_ones+1)

        for (b_ones = 0; b_ones < 10; b_ones=b_ones+1)
        for (b_tens = 0; b_tens < 10; b_tens=b_tens+1)
        for (b_huns = 0; b_huns < 10; b_huns=b_huns+1)
        begin

            a = {a_huns, a_tens, a_ones};
            b = {b_huns, b_tens, b_ones};

            if (a > b) begin
                bin = a - b;
                #10;
                $display("%h - %h = %d %d %d", a, b, huns, tens, ones);
            end
        end
*/
        for (a_huns = 0; a_huns < 10; a_huns=a_huns+1)
        for (a_tens = 0; a_tens < 10; a_tens=a_tens+1)
        for (a_ones = 0; a_ones < 10; a_ones=a_ones+1)
        begin
            bin = {a_huns, a_tens, a_ones};
            #10;
            $display("%h = %d%d%d", bin, huns, tens, ones);
        end

        $stop;
    end

endmodule
