module Barrel_Shifter(SH_DIR, SH_AMT, D_IN, D_OUT);

	input  SH_DIR;
	input  [4:0] SH_AMT;
	input  [31:0] D_IN;
	output [31:0] D_OUT;
	reg    [31:0] D_OUT;
	
	reg    [4:0] SHL_AMT;
	reg    [4:0] SHR_AMT;

	wire   [31:0] D_RIGHT;
	wire   [31:0] D_LEFT;

	Shl S_Shl(SHL_AMT, D_IN, D_LEFT);
	Shr S_Shr(SHR_AMT, D_IN, D_RIGHT);

	always @(SH_DIR, SH_AMT, D_IN, D_RIGHT, D_LEFT) begin
		if (SH_DIR == 1'b1) begin
			SHR_AMT = SH_AMT;
			SHL_AMT = 0;
			D_OUT <= D_RIGHT;
		end
		else begin
			SHL_AMT = SH_AMT;
			SHR_AMT = 0;
			D_OUT <= D_LEFT;
		end
	end

endmodule