`timescale 1 ns/1 ns

module Shr_8(SH, D_IN, D_OUT);

	input SH;
	input  [31:0] D_IN;
	output [31:0] D_OUT;
	reg    [31:0] D_OUT;

	// CombLogic
	always @(SH, D_IN) begin
		if(SH == 1'b1) begin
			if(D_IN[31] == 1'b1)
				D_OUT <= {8'hFF, D_IN[31:8]};
			else
				D_OUT <= {8'h0, D_IN[31:8]};
		end
		else
			D_OUT <= D_IN;
	end
endmodule