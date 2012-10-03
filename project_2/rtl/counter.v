`include "constants.h"

module counter(
    input clk,
    input rst,
    input en,
    output reg [6:0] base = 0,
    output reg [3:0] exponent = 0
);

    reg [36:0] count = 0;
    reg [36:0] base_count = 0;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            count = 0;
            exponent = 0;
        end else if (en) begin
            
            count = count + 1;
            base_count = base_count + 1;

            case (exponent)
                0: base = base + 1;
                1: if (base_count == 10**01) begin base = base + 1; base_count = 0; end
                2: if (base_count == 10**02) begin base = base + 1; base_count = 0; end
                3: if (base_count == 10**03) begin base = base + 1; base_count = 0; end
                4: if (base_count == 10**04) begin base = base + 1; base_count = 0; end
                5: if (base_count == 10**05) begin base = base + 1; base_count = 0; end
                6: if (base_count == 10**06) begin base = base + 1; base_count = 0; end
                7: if (base_count == 10**07) begin base = base + 1; base_count = 0; end
                8: if (base_count == 10**08) begin base = base + 1; base_count = 0; end
                9: if (base_count == 10**09) begin base = base + 1; base_count = 0; end
            endcase                      

            case (exponent)
                0: if (count == 10**02)        begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                1: if (count == 10**03-10**02) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                2: if (count == 10**04-10**03) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                3: if (count == 10**05-10**04) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                4: if (count == 10**06-10**05) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                5: if (count == 10**07-10**06) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                6: if (count == 10**08-10**07) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                7: if (count == 10**09-10**08) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                8: if (count == 10**10-10**09) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
                9: if (count == 10**11-10**10) begin count = 0; base_count = 0; base = 10; exponent = exponent + 1; end
            endcase
        end
    end

endmodule
