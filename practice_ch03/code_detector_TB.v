`timescale 1 ns/1 ns

module Testbench();

	reg Start_s, Red_s, Green_s, Blue_s;
	reg Clk_s, Rst_s;
	wire U_s;
	// 16 bit reg --> 12 bit
	reg [15:0] Index;
	reg [15:0] Key;

	Code_Detector CompToTest(Start_s, Red_s, Green_s, Blue_s, Clk_s, Rst_s, U_s);
	
	// Clock Procedure
	always begin
		Clk_s <= 0;
		#10;
		Clk_s <= 1;
		#10;
	end

	// Vector Procedure
	initial begin
		// for loop
		for(Index=16'h0000; Index<16'h1000; Index=Index+16'h0001)
		begin
			// initialization
			Rst_s <= 1;
			Start_s <= 0;
			Red_s <= 0;
			Blue_s <= 0;
			Green_s <= 0;
			@(posedge Clk_s);

			Rst_s <= 0;
			Start_s <= 1;
			#5 if (U_s != 1)
				$display("Output is 1 when wait state!");
			@(posedge Clk_s);

			Red_s <= Index[2];
			Green_s <= Index[1];
			Blue_s <= Index[0];
			#5;
			if (U_s == 1)
				$display("Output is 1 when start state!");
			@(posedge Clk_s);

			Red_s <= Index[5];
			Green_s <= Index[4];
			Blue_s <= Index[3];
			#5;
			if (U_s == 1)
				$display("Output is 1 when red1 state!");
			@(posedge Clk_s);

			Red_s <= Index[8];
			Green_s <= Index[7];
			Blue_s <= Index[6];
			#5;
			if (U_s == 1)
				$display("Output is 1 when blue state!");
			@(posedge Clk_s);

			Red_s <= Index[11];
			Green_s <= Index[10];
			Blue_s <= Index[9];
			#5;
			if (U_s == 1)
				$display("Output is 1 when green state!");
			@(posedge Clk_s);
			
			#5;
			if (U_s == 1) begin
				if(Index == 16'b0000_100_010_001_100) begin
					$display("#%d: %3b_%3b_%3b_%3b is correct!", Index, Index[11:9], Index[8:6], Index[5:3], Index[2:0]);
					Key <= Index;
				end
				else
					$display("#%d: Door opens with incorrect sequence - %3b_%3b_%3b_%3b", Index, Index[11:9], Index[8:6], Index[5:3], Index[2:0]);
			end
			else
				$display("#%d: %3b_%3b_%3b_%3b is incorrect!", Index, Index[11:9], Index[8:6], Index[5:3], Index[2:0]);
			@(posedge Clk_s);
		end

		$display("#%d: %3b_%3b_%3b_%3b is correct!", Key, Key[11:9], Key[8:6], Key[5:3], Key[2:0]);
		$stop;

  end
endmodule