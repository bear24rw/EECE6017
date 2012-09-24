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
				
				
			// The following section will test the temperature input
			// from 0 to 50 (not comprehensive) this will cover standard 
			// increments that will not trigger a '>5' alarm
			// as well as show that each state works
			
			
			// Normal operation
			
        #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h000);    // enter the number
        #100;
        $display("------------------------");

        #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h010);    // enter the number
        #100;
        $display("------------------------");

        #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h020);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h030);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h040);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h050);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h390);    // enter the number
        #100;
        $display("------------------------");
		  
		  // End Normal Operation
		  // The ">5" alarm should go off now. 
		  // Begin Borderline Operation
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h400);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h410);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h420);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h430);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h440);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h450);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h460);    // enter the number
        #100;
        $display("------------------------");
		  
		  // End Borderline Operation
		  // Begin Attention Operation
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h470);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h480);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h490);    // enter the number
        #100;
        $display("------------------------");
		  
		  // End Attention Operation
		  // Begin Emergency Operation
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h500);    // enter the number
        #100;
        $display("------------------------");
		  
		  // Out of range alarm should be going off now.
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h510);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h520);    // enter the number
        #100;
        $display("------------------------");

		  // This next group will test the delta alarm going off
		  // (if the change in temp is greater than 5)
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h000);    // enter the number
        #100;
        $display("------------------------");
		  
		  // start it with the alarm off
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h000);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h070);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h360);    // enter the number
        #100;
        $display("------------------------");
		  
		  // turn off the alarm by not changing the temp
		  // The next jump will cross a borderline from 
		  // normal to attention. alarm should still go off
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h360);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h420);    // enter the number
        #100;
        $display("------------------------");
		  
		  // This will test for the case when the temperature
		  // increments greater than 5, but also out of range
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h460);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h540);    // enter the number
        #100;
        $display("------------------------");
		  
		  // This test will drop from out of range into attention mode
		  // A delta of >5.
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h470);    // enter the number
        #100;
        $display("------------------------");
		  
		  // This will test a massive drop  from 47 to 5
		  // start with the >5 alarm off (attention alarm is on)
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h470);    // enter the number
        #100;
        $display("------------------------");
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h050);    // enter the number
        #100;
        $display("------------------------");
		  
		  // The alarm should turn off after this reading
		  
		  #100 pulse_enter;             // start entering a new number
        #100 enter_value(12'h50);    // enter the number
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
