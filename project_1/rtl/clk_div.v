module clk_div(
    input clk_in,
    output reg clk_out = 0
);

    // default the clock divider to 1Hz
    // the DE1 has a 50MHz oscillator so
    // toggle every 25 million clocks
    parameter COUNT = 25000000;

    // register needs to be ln(25000000)/ln(2)
    // bits wide to handle 1Hz
    reg [24:0] counter = 0;

    always @(posedge clk_in) begin
        
        // increment the counter every pulse
        counter = counter + 1;

        // if we have counted up to our desired value
        if (counter == COUNT) begin
            // toggle the output clock
            clk_out = ~clk_out;
            // reset the counter
            counter = 0;
        end

    end

endmodule
        
