module pulse_led(
    input clk,
    output reg led
);

    parameter period    = 500000;
    parameter step_size = 20000;

    reg [28:0] counter = 0;
    reg [28:0] ccr = 0;
    reg dir = 0;

    always @(posedge clk) begin
        counter = counter + 1;

        if (counter < ccr)
            led = dir ? 1 : 0;
        else
            led = dir ? 0 : 1;

        if (counter == period) begin
            counter = 0;

            ccr = ccr + step_size;
            if (ccr > period) begin
                ccr = 0;
                dir = ~dir;
            end
        end
    end

endmodule

