module top_tb();

    reg CLOCK_50 = 0;
    reg [3:0] KEY = 0;
    reg [9:0] SW = 0;
    wire [7:0] LEDG;
    wire [9:0] LEDR;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;

    top uut(
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .SW(SW),
        .LEDG(LEDG),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    always
        #1 CLOCK_50 = ~CLOCK_50;

    initial begin
        $monitor("%b | %b | disp_mode: %b | input_state: %b | temp state: %b | temp_value_bcd: %b", 
            LEDR, LEDG, uut.disp_mode, uut.input_state, uut.state, uut.monitor.temp_value_bcd);
    end

endmodule
