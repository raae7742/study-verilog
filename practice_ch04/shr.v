`timescale 1 ns/1 ns

module Shr(SH_AMT, D_IN, D_OUT);

	input  [4:0] SH_AMT;
	input  [31:0] D_IN;
	output [31:0] D_OUT;
	wire   [31:0] D16;
	wire   [31:0] D08;
	wire   [31:0] D04;
	wire   [31:0] D02;
	
	Shr_16 S_Shr_16(SH_AMT[4], D_IN, D16);
	Shr_8 S_Shr_8(SH_AMT[3], D16, D08);
	Shr_4 S_Shr_4(SH_AMT[2], D08, D04);
	Shr_2 S_Shr_2(SH_AMT[1], D04, D02);
	Shr_1 S_Shr_1(SH_AMT[0], D02, D_OUT);

endmodule		