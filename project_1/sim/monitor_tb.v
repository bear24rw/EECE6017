module monitor_tb();

    reg clk = 0;
    reg rst = 0;
    reg en = 0;
    reg mode = 0;

    reg [3:0] temp_value_ones;
    reg [3:0] temp_value_tens;
    reg [3:0] temp_value_huns;
    wire temp_value_sign;

    wire [3:0] temp_delta_ones;
    wire [3:0] temp_delta_tens;
    wire [3:0] temp_delta_huns;
    wire  temp_delta_sign;

    wire [3:0] state;

    monitor uut(
        .clk(clk),
        .rst(rst),
        .en(en),
        .mode(mode),

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

    always
        #1 clk = ~clk;


    reg [3:0] a_ones;
    reg [3:0] a_tens;
    reg [3:0] a_huns;

    initial begin
        #50; 
        mode = 0;
        en = 1;

        #10 rst = 0;
        #10 rst = 1; 
        #10 rst = 0;

        for (a_huns = 0; a_huns < 10; a_huns=a_huns+1)
        for (a_tens = 0; a_tens < 10; a_tens=a_tens+1)
        for (a_ones = 0; a_ones < 10; a_ones=a_ones+1)
        begin
            temp_value_ones = a_ones;
            temp_value_tens = a_tens;
            temp_value_huns = a_huns;

            #100; 

            $display("%d%d%d  %d%d%d  %d", temp_value_huns,
                                           temp_value_tens,
                                           temp_value_ones,
                                           temp_delta_huns,
                                           temp_delta_tens,
                                           temp_delta_ones,
                                           state);
        end

        $stop;
    end

endmodule
