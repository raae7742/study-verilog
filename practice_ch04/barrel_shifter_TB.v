`timescale 1 ns/1 ns

module Testbench();

	reg SH_DIR_s;
	reg [4:0] SH_AMT_s;
	reg [31:0] D_IN_s;
	wire [31:0] D_OUT_s;
	
	integer Index;

	Barrel_Shifter CompToTest(SH_DIR_s, SH_AMT_s, D_IN_s, D_OUT_s);

	initial begin
		$display("# 1.Shift-Right Operation Test with Negative Value!");
		for(Index = 0; Index<32; Index=Index+1) begin
			SH_DIR_s <= 1'b1;
			D_IN_s <= 32'h8000_0000;
			SH_AMT_s <= Index;
			#10;
			$display("# shift-right with amount %d is %b", SH_AMT_s, D_OUT_s);
		end

		$display("# 2.Shift-Right Operation Test with Positive Value!");
		for(Index = 0; Index<32; Index=Index+1) begin
			D_IN_s <= 32'b0100_0000_0000_0000_0000_0000_0000_0000;
			SH_AMT_s <= Index;
			#10;
			$display("# shift-right with amount %d is %b", SH_AMT_s, D_OUT_s);
		end

		$display("# 3.Shift-Left Operation Test with Number 1!");
		for(Index = 0; Index<32; Index=Index+1) begin
			SH_DIR_s <= 1'b0;
			D_IN_s <= 32'h0000_0001;
			SH_AMT_s <= Index;
			#10;
			$display("# shift-left with amount %d is %b", SH_AMT_s, D_OUT_s);
		end		
	end
endmodule