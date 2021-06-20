`timescale 1 ns/1 ns
`define A_WIDTH 8
`define D_WIDTH 8
`define ITR 64

module Testbench();
	reg 				Go_t_s;
	wire 				Done_t_s;
	wire [19:0] Result_s;
	reg 				Rst_Core_s;
	reg  [31:0] M_di32_s;
 	wire [7:0]  M_di8_s;
	wire [31:0] M_do32_s;
	reg  [5:0]  M_Addr6_s;
	reg 				M_enb_s;
	reg 				M_web_s;
	reg 				Rst_M_s;
	reg 				Clk_s;

	reg [31:0] 	A[0:(2**(`A_WIDTH-2)-1)];
	reg [19:0] 	Ref[0:(`ITR-1)];
	integer Index;
	parameter ClkPeriod = 20;

 	FINAL_Top CompToTest(
		Go_t_s,
		Done_t_s,
		Result_s,
		Rst_Core_s,
		M_di32_s,
 		M_di8_s,
		M_do32_s,
		M_Addr6_s,
		M_enb_s,
		M_web_s,
	  Rst_M_s,
		Clk_s
	);

	//Clock Procedure
	always begin
		Clk_s <= 1'b0; #(ClkPeriod/2);
		Clk_s <= 1'b1; #(ClkPeriod/2);
	end

	// Initialize Arrays
	initial $readmemh("../sw/MemA.txt", A);
	initial $readmemh("../sw/sw_result.txt", Ref);

	// Vector Procedure
	initial begin
		Rst_M_s <= 1'b0; Rst_Core_s <= 1'b1; Go_t_s <= 1'b0;
		M_enb_s <= 1'b0; M_web_s <= 1'b0;
		@(posedge Clk_s);

		Rst_M_s <= 1'b0;
		@(posedge Clk_s);

		for(Index=0; Index<(2**(`A_WIDTH-2)); Index=Index+1) begin
			M_enb_s <= 1'b1;
			M_web_s <= 1'b1;
			M_Addr6_s <= Index;
			M_di32_s <= A[Index];
			@(posedge Clk_s);
		end

		M_enb_s <= 1'b0;
		M_web_s <= 1'b0;
		@(posedge Clk_s);

		//Running FINAL-Core
		Rst_Core_s <= 0; Go_t_s <= 1'b1;
		@(posedge Clk_s);

		Go_t_s <= 1'b0;
		@(posedge Clk_s);

		for(Index=0; Index<`ITR; Index=Index+1) begin
			while(Done_t_s != 1'b1)
				@(posedge Clk_s);

			if (Result_s != Ref[Index]) begin
				$display("FINAL failed with %x-- should equal to %x", Result_s, Ref[Index]);
				$display("FINAL failed with %x-- should equal to %x", Result_s, Ref[0]);
				$display("FINAL failed with %x-- should equal to %x", Result_s, Ref[1]);
			end
			else
				$display("FINAL is %x that is equal to %x", Result_s, Ref[Index]);
			@(posedge Clk_s);
		end
		$stop;
	end

endmodule
