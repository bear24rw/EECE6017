module divide(clk, valIn, average);

	input clk;
	input [7:0] valIn;
	output reg [7:0] average;
	
	reg [7:0] firstVal = 8'b00000000;
	reg [7:0] secondVal = 8'b00000000;
	reg [7:0] thirdVal = 8'b00000000;
	
	always @(posedge clk)
	begin
		thirdVal <= secondVal;
		secondVal <= firstVal;
		firstVal <= valIn/3;
		average <= firstVal + secondVal + thirdVal;
	end
	
/*	always @(negedge clk)
	begin
		average <= firstVal + secondVal + thirdVal;
	end */
	
endmodule
