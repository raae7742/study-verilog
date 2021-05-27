`timescale 1 ns/1 ns

module Shl(SH_AMT, D_IN, D_OUT);

	input  [4:0] SH_AMT;
	input  [31:0] D_IN;
	output [31:0] D_OUT;
	wire   [31:0] D16;
	wire   [31:0] D08;
	wire   [31:0] D04;
	wire   [31:0] D02;
	
	Shl_16 S_Shl_16(SH_AMT[4], D_IN, D16);
	Shl_8 S_Shl_8(SH_AMT[3], D16, D08);
	Shl_4 S_Shl_4(SH_AMT[2], D08, D04);
	Shl_2 S_Shl_2(SH_AMT[1], D04, D02);
	Shl_1 S_Shl_1(SH_AMT[0], D02, D_OUT);

endmodule		