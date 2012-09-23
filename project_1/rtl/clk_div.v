module clk_div(
    input clk_in,
    output reg clk_out = 0
);

    parameter COUNT = 25000000;

    reg [27:0] counter = 0;

    always @(posedge clk_in) begin
        counter = counter + 1;
        if (counter == COUNT) begin
            clk_out = ~clk_out;
            counter = 0;
        end
    end

endmodule
        
