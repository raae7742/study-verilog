`timescale 1 ns/1 ns

module Shr_4(SH, D_IN, D_OUT);

	input SH;
	input  [31:0] D_IN;
	output [31:0] D_OUT;
	reg    [31:0] D_OUT;

	// CombLogic
	always @(SH, D_IN) begin
		if(SH == 1'b1) begin
			if(D_IN[31] == 1'b1)
				D_OUT <= {4'b1111, D_IN[31:4]};
			else
				D_OUT <= {4'b0000, D_IN[31:4]};
		end
		else
			D_OUT <= D_IN;
	end
endmodule