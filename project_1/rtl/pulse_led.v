module pulse_led(
    input clk,
    output reg led = 0
);

    // simple pwm pulsing

    // 'counter' just keeps counting up to PERIOD.
    // if 'counter' is greater than 'compare' the
    // led gets either turned on or off depending on 
    // which direction we are pulsing.
    // every time 'counter' reaches PERIOD 'compare'
    // is increased by STEP_SIZE.
    // we are essentially sweeping the duty cycle 
    // from 0% to 100% by (step_size/period)%

    parameter period    = 500000;
    parameter step_size = 20000;

    reg [28:0] counter = 0;
    reg [28:0] compare = 0;
    reg dir = 0;

    always @(posedge clk) begin
        counter = counter + 1;

        if (counter < compare)
            led = dir ? 1 : 0;
        else
            led = dir ? 0 : 1;

        if (counter == period) begin
            counter = 0;

            compare = compare + step_size;
            if (compare > period) begin
                compare = 0;
                dir = ~dir;
            end
        end
    end

endmodule

