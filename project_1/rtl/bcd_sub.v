// implements bcd excess-3 coding subtraction
// out = a - b

module bcd_sub(
    input [3:0] a_ones,
    input [3:0] a_tens,
    input [3:0] a_huns,

    input [3:0] b_ones,
    input [3:0] b_tens,
    input [3:0] b_huns,

    output reg [3:0] out_ones = 0,
    output reg [3:0] out_tens = 0,
    output reg [3:0] out_huns = 0,

    output reg negative = 0
);

    // when we subtract the two numbers they will be catted
    // together to make a 12 bit number. the result will be stored
    // in this register
    reg [11:0] out = 0;

    always @(*) begin

        // we are not doing signed bcd so we need to check which
        // value is bigger so we can always subtract the bigger
        // one from the smaller one
        if ({a_huns,a_tens,a_ones} > {b_huns,b_tens,b_ones}) begin

            // add 3 to each digit and then combine them all and subtract
            out = {(a_huns+4'd3), (a_tens+4'd3), (a_ones+4'd3)} -
                  {(b_huns+4'd3), (b_tens+4'd3), (b_ones+4'd3)};

            // now that we subtracted break the result back apart into bcd
            out_huns = out[11:8];
            out_tens = out[7:4];
            out_ones = out[3:0];

            // if any digit needed to borrow we need to subtract 6
            // from it according to the algorithm
            if (b_huns > a_huns) out_huns = out_huns - 6;
            if (b_tens > a_tens) out_tens = out_tens - 6;
            if (b_ones > a_ones) out_ones = out_ones - 6;

            // we are always doing 'out = a - b' so in this case
            // the result is positive
            negative = 0;

        end else begin

            // add 3 to each digit and then combine them all and subtract
            out = {(b_huns+4'd3), (b_tens+4'd3), (b_ones+4'd3)} -
                  {(a_huns+4'd3), (a_tens+4'd3), (a_ones+4'd3)};

            // now that we subtracted break the result back apart into bcd
            out_huns = out[11:8];
            out_tens = out[7:4];
            out_ones = out[3:0];

            // if any digit needed to borrow we need to subtract 6
            // from it according to the algorithm
            if (a_huns > b_huns) out_huns = out_huns - 6;
            if (a_tens > b_tens) out_tens = out_tens - 6;
            if (a_ones > b_ones) out_ones = out_ones - 6;

            // we are always doing 'out = a - b' so in this case
            // the result is negative
            negative = 1;

        end

        // check to make sure each digit is a valid number
        // if it is not subtract 6 as per the algorithm
        if (out_ones > 9) out_ones = out_ones - 6;
        if (out_tens > 9) out_tens = out_tens - 6;
        if (out_huns > 9) out_huns = out_huns - 6;

    end

endmodule

