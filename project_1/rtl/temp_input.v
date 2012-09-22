`include "constants.h"

module temp_input(
    input rst,

    input enter,
    input [3:0] value,

    output [3:0] current_value,

    output reg [1:0] state,

    output reg [3:0] temp_value_ones,
    output reg [3:0] temp_value_tens,
    output reg [3:0] temp_value_huns
);

    initial state = `INPUT_STATE_ONES;

    always @(posedge enter, posedge rst) begin
        if (rst) begin
            state = `INPUT_STATE_ONES;
        end else begin
            case (state)
                `INPUT_STATE_ONES: begin
                    temp_value_ones = current_value;
                    state = `INPUT_STATE_TENS;
                end
                `INPUT_STATE_TENS: begin
                    temp_value_tens = current_value;
                    state = `INPUT_STATE_HUNS;
                end
                `INPUT_STATE_HUNS: begin
                    temp_value_huns = current_value;
                    state = `INPUT_STATE_DONE;
                end
                `INPUT_STATE_DONE: begin
                    state = `INPUT_STATE_ONES;
                end
            endcase
        end
    end

    assign current_value = (value < 10) ? value : 9;

endmodule
