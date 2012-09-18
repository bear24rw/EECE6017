module top(
    input CLOCK_50,
    input [3:0] KEY,
    input [9:0] SW,
    output [7:0] LEDG,
    output [9:0] LEDR,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3
);

    parameter STATE_NORMAL      = 0;
    parameter STATE_BORDERLINE  = 1;
    parameter STATE_ATTENTION   = 2;
    parameter STATE_EMERGENCY   = 3;

    // -------------------------------------------------
    //              1 HZ CLOCK
    // -------------------------------------------------

    // divide the 50MHz clock down to 1Hz
    wire clk_1hz;
    clk_div clk_div(CLOCK_50, clk_1hz);

    // -------------------------------------------------
    //              DISPLAY TOGGLE
    // -------------------------------------------------

    // toggle the 7 seg display mode every second
    // disp_mode = 1 : showing temp
    // disp_mode = 0 : showing state
    reg disp_mode = 1;
    always @(posedge clk_1hz)
        disp_mode <= ~disp_mode;

    // -------------------------------------------------
    //              TEMP MODE
    // -------------------------------------------------

    // toggle the mode we're in (pos or neg temps)
    // display it on LEDG0
    // mode = 1 : negative temps
    // mode = 0 : positive temps
    reg mode = 0;
    always @(posedge KEY[0])
        mode <= ~mode;
    assign LEDG[0] = mode;

    // -------------------------------------------------
    //              TEMP VALUE
    // -------------------------------------------------

    reg [5:0] temp;
    reg [3:0] temp_frac;

    always @(SW) begin
        temp <= SW[9:4];
        if (SW[3:0] < 9)
            temp_frac <= SW[3:0];
        else
            temp_frac <= 9;
    end

    // -------------------------------------------------
    //              TEMP MONITOR
    // -------------------------------------------------

    wire [3:0] state;

    monitor monitor(
        .clk(clk_1hz),
        .mode(mode),
        .temp(temp),
        .temp_frac(temp_frac),
        .state(state)
    );

    // -------------------------------------------------
    //                  7 SEGS
    // -------------------------------------------------

    // convert the temperature into BCD
    wire [3:0] temp_bcd_tens;
    wire [3:0] temp_bcd_ones;
    wire [3:0] temp_bcd_frac;

    bin_2_bcd bcd(
        .bin(temp),
        .ones(temp_bcd_ones),
        .tens(temp_bcd_tens),
        .hundreds()
    );

    bin_2_bcd bcd_frac(
        .bin(temp_frac),
        .ones(temp_bcd_frac),
        .tens(),
        .hundreds()
    );

    // mux the seven segs depending on what display mode were in
    wire [3:0] seg_0;
    wire [3:0] seg_1;
    wire [3:0] seg_2;

    assign seg_0 = disp_mode ? temp_bcd_frac : 0;
    assign seg_1 = disp_mode ? temp_bcd_ones : 0;
    assign seg_2 = disp_mode ? temp_bcd_tens : 0;

    seven_seg s0(seg_0, HEX0);
    seven_seg s1(seg_1, HEX1);
    seven_seg s2(seg_2, HEX2);

    assign HEX3 = (mode & disp_mode) ? 7'b0111111: 7'b1111111;


    // -------------------------------------------------
    //                  ALARM
    // -------------------------------------------------
    
    wire pulse_led_slow;
    wire pulse_led_fast;

    pulse_led #(.step_size(1000)) pulse_slow (CLOCK_50, pulse_led_slow);
    pulse_led #(.step_size(60000)) pulse_fast (CLOCK_50, pulse_led_fast);

    assign LEDR[9:0] = 
        (state == STATE_ATTENTION) ? {9{pulse_led_slow}} :
        (state == STATE_EMERGENCY) ? {9{pulse_led_fast}} :
        {9{1'b0}};
            


endmodule
