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
        .KEY(~KEY),
        .SW(SW),
        .LEDG(LEDG),
        .LEDR(LEDR),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end

    always
        #1 CLOCK_50 = ~CLOCK_50;

    initial begin
        /*
        $monitor("%b | %b | disp_mode: %b | input_state: %b | temp state: %b | temp_value_bcd: %b", 
            LEDR, LEDG, uut.disp_mode, uut.input_state, uut.state, uut.monitor.temp_value_bcd);
        */
        $display("input_state | disp_mode | seg enables");
        $monitor("%d | %d | %d%d%d", uut.input_state, uut.disp_mode,
            uut.seg_0_en,
            uut.seg_1_en,
            uut.seg_2_en,
            uut.seg_3_en);

        #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h123);    // enter the number
        #100;
        $display("------------------------");

        #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h875);    // enter the number
        #100;
        $display("------------------------");

        #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h440);    // enter the number
        #100;
        $display("------------------------");

        #5000;
        $finish;
    end

    task pulse_enter; begin
        #50 KEY[3] = 1; #50 KEY[3] = 0; 
    end
    endtask

    task enter_value;
        input [11:0] val;
        begin
            #50 SW[3:0] = val[3:0];
            #50 pulse_enter;
            #50 SW[3:0] = val[7:4];
            #50 pulse_enter;
            #50 SW[3:0] = val[11:8];
            #50 pulse_enter;
        end
    endtask

endmodule
