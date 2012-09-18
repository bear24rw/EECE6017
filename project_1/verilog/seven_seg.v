module seven_seg(
    input [3:0] value,
    output reg [6:0] seg
);

    always @(value)
        case (value)
            'h0: seg <= 7'b1111111;
            'h1: seg <= 7'b1111001;
            'h2: seg <= 7'b0100100;
            'h3: seg <= 7'b0110000;
            'h4: seg <= 7'b0011001;
            'h5: seg <= 7'b0010010;
            'h6: seg <= 7'b0000010;
            'h7: seg <= 7'b1111000;
            'h8: seg <= 7'b0000000;
            'h9: seg <= 7'b0010000;
            'hA: seg <= 7'b0001000;
            'hB: seg <= 7'b0000011;
            'hC: seg <= 7'b1000110;
            'hD: seg <= 7'b0100001;
            'hE: seg <= 7'b0000110;
            'hF: seg <= 7'b0001110;
            default: seg <= 7'b1110110;
        endcase

endmodule

