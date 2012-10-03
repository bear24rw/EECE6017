module bin_2_bcd (
    input [11:0] bin,
    output reg [3:0] tens,
    output reg [3:0] ones
);

    reg [3:0] num_shifts = 0;
    reg [11:0] binary = 0;

    always @(*) begin

        num_shifts = 0;
        tens = 0;
        ones = 0;

        binary = bin;

        while (num_shifts < 8) begin
            
            if (tens >= 5)
                tens = tens + 3;
            if (ones >= 5)
                ones = ones + 3;

            tens = tens << 1;
            tens[0] = ones[3];

            ones = ones << 1;
            ones[0] = binary[11];

            binary = binary << 1;

            num_shifts = num_shifts + 1;

        end
    end

endmodule
