`include "constants.h"

module counter(
    input clk,
    input rst,
    input en,
    output reg [6:0] base = 0,
    output reg [3:0] exponent = 0
);

    reg [29:0] count = 0;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            base = 0;
            exponent = 0;
            count = 0;
        end else if (en) begin
            
            count = count + 1;

            case (exponent)
                0: if (count == 10**00) begin base = base + 1; count = 0; end
                1: if (count == 10**01) begin base = base + 1; count = 0; end
                2: if (count == 10**02) begin base = base + 1; count = 0; end
                3: if (count == 10**03) begin base = base + 1; count = 0; end
                4: if (count == 10**04) begin base = base + 1; count = 0; end
                5: if (count == 10**05) begin base = base + 1; count = 0; end
                6: if (count == 10**06) begin base = base + 1; count = 0; end
                7: if (count == 10**07) begin base = base + 1; count = 0; end
                8: if (count == 10**08) begin base = base + 1; count = 0; end
                9: if (count == 10**09) begin base = base + 1; count = 0; end
            endcase                      

            if (base == 100) begin 
                base = 10; 
                exponent = exponent + 1; 
            end
        end
    end

endmodule
