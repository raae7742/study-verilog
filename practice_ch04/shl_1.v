`timescale 1 ns/1 ns

module Shl_1(SH, D_IN, D_OUT);
	input  SH;
	input  [31:0] D_IN;
	output [31:0] D_OUT;
	reg    [31:0] D_OUT;

	// CombLogic
	always @(SH, D_IN) begin
		if(SH == 1'b1)
			D_OUT <= {D_IN[30:0], 1'b0};
		else
			D_OUT <= D_IN;
	end
endmodule