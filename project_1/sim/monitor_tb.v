module monitor_tb();

    reg clk = 0;
    reg rst = 0;
    reg en = 0;

    reg [3:0] temp_value_ones;
    reg [3:0] temp_value_tens;
    reg [3:0] temp_value_huns;
    reg       temp_value_sign;

    reg [3:0] temp_delta_ones;
    reg [3:0] temp_delta_tens;
    reg [3:0] temp_delta_huns;
    reg       temp_delta_sign;

    wire [3:0] state;

    monitor uut(
        .rst(rst),
        .en(en),

        .temp_value_ones(temp_value_ones),
        .temp_value_tens(temp_value_tens),
        .temp_value_huns(temp_value_huns),
        .temp_value_sign(temp_value_sign),

        .temp_delta_ones(temp_delta_ones),
        .temp_delta_tens(temp_delta_tens),
        .temp_delta_huns(temp_delta_huns),
        .temp_delta_sign(temp_delta_sign),

        .state(state)
    );

    initial begin
        $dumpfile("monitor_tb");
        $dumpvars(0, monitor_tb);
    end


    reg [3:0] a_ones;
    reg [3:0] a_tens;
    reg [3:0] a_huns;

    initial begin
        #50; 

        en = 0;
        temp_value_sign = 0;

        #10 rst = 0;
        //#10 rst = 1; 
        //#10 rst = 0;

        $display("temp_value | temp_value_old | temp_delta");
        for (a_huns = 0; a_huns < 10; a_huns=a_huns+1)
        for (a_tens = 0; a_tens < 10; a_tens=a_tens+4)
        for (a_ones = 0; a_ones < 10; a_ones=a_ones+3)
        begin
            temp_delta_ones = 3;
            temp_delta_tens = 3;
            temp_delta_huns = 0;

            temp_value_ones = a_ones;
            temp_value_tens = a_tens;
            temp_value_huns = a_huns;

            #1 en = 1; #1 en = 0;

            #100; 
            /*
            $display("%d%d%d  %d%d%d  %d%d%d | state = %d", 
                temp_value_huns, temp_value_tens, temp_value_ones,
                uut.temp_value_huns_old, uut.temp_value_tens_old, uut.temp_value_ones_old,
                temp_delta_huns, temp_delta_tens, temp_delta_ones,
                state
            );
            */
            $display("%d%d%d  %d%d%d | state = %d", 
                temp_value_huns, temp_value_tens, temp_value_ones,
                temp_delta_huns, temp_delta_tens, temp_delta_ones,
                state
            );

        end

        //$stop;
        $finish;
    end

endmodule
