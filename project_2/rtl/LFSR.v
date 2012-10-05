module LFSR(clk, en, lfsr);

	input clk;
    input en;
	output reg [7:0] lfsr = 8'b10011011;

	wire bit0;
	
	xnor(bit0, lfsr[7], lfsr[5], lfsr[2], lfsr[1]);
	
	always @(posedge clk)
	begin
        if (en)
			lfsr <= {lfsr[6:0],bit0};
	end	
endmodule
