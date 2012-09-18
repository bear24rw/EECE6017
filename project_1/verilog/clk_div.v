module clk_div(
    input clk_50mhz,
    output reg clk_1hz
);

    reg [27:0] counter = 0;

    initial clk_1hz = 0;

    always @(posedge clk_50mhz) begin
        counter = counter + 1;
        if (counter == 25000000) begin
            clk_1hz = ~clk_1hz;
            counter = 0;
        end
    end

endmodule
        
