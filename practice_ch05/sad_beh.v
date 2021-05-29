`timescale 1 ns/1 ns
`define D_WIDTH 8
`define A_WIDTH 15
`define C_WIDTH 7
`define ITR	128

module SAD(Go, A_Addr, A_Data,
					B_Addr, B_Data, C_Addr,
					I_RW, I_En, O_RW, O_En,
					Done, SAD_Out, Clk, Rst);

	input Go;
	input [(`D_WIDTH-1):0] A_Data, B_Data;
	output reg [(`A_WIDTH-1):0] A_Addr, B_Addr;
	output reg [(`C_WIDTH-1):0] C_Addr;
	output reg I_RW, I_En, O_RW, O_En, Done;
	output reg [31:0] SAD_Out;
	input Clk, Rst;

	parameter S0 = 3'b000, S1 = 3'b001,
						S2 = 3'b010, S3a = 3'b011,
						S3 = 3'b100, S4 = 3'b101;

	reg [2:0] State;
	reg [2:0] StateNext;
	reg [31:0] Sum;
	integer I, J, K;

	function [(`D_WIDTH-1):0] ABSDiff;
		input [(`D_WIDTH-1):0] A;
		input [(`D_WIDTH-1):0] B;
		if (A>B) ABSDiff = A - B;
		else ABSDiff = B - A;
	endfunction

	always @(posedge Clk) begin
		A_Addr <= {`A_WIDTH{1'b0}};
		B_Addr <= {`A_WIDTH{1'b0}};
		I_RW <= 1'b0;
		I_En <= 1'b0;
		O_RW <= 1'b0;
		O_En <= 1'b0;
		Done <= 1'b0;
		SAD_Out <= 32'b0;

		if (Rst == 1'b1) begin
			State <= S0;
			Sum <= 32'b0;
			I <= 0;
			J <= 0;
			K <= 0;
		end
		else begin
			C_Addr <= {`C_WIDTH{1'b0}};
			State <= StateNext;
		end
	end

	// CombLogic
	always @(State, Go) begin
		case(State)
			S0: begin

				if (Go==1'b1) begin
					I <= 0;
					J <= 0;
					K <= 0;
					StateNext <= S1;
				end
				else
					StateNext <= S0;
			end
			S1: begin
				Sum <= 32'b0;
				J <= 1'b0;
				StateNext <= S2;
			end
			S2: begin
				if (J<256) begin
					StateNext <= S3a;
					A_Addr <= I;
					B_Addr <= I;
					I_RW <= 0;
					I_En <= 1;
				end
				else
					StateNext <= S4;
			end
			S3a:
				State <= S3;
			S3: begin
				Sum <= Sum + ABSDiff(A_Data, B_Data);
				I <= I+1;
				J <= J+1;
				StateNext <= S2;	
			end
			S4: begin
				SAD_Out <= Sum;
				C_Addr <= K;
				K <= K+1;
				O_RW <= 1;
				O_En <= 1;
				if(K < 32768)
					StateNext <= S1;
				else begin
					Done <= 1'b1;
					StateNext <= S0;
				end
			end
			default: begin
				StateNext <= S0;
			end
		endcase
	end

endmodule