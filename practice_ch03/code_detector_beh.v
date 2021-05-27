`timescale 1 ns/1 ns

module Code_Detector(Start, R, G, B, Clk, Rst, U);

	input Start, R, G, B;
	output reg U;
	input Clk, Rst;

	parameter S_Wait = 0, S_Start = 1, S_Red1 = 2, 
						S_Blue = 3, S_Green = 4, S_Red2 = 5;

	reg [2:0] State, StateNext;
	
	// StateReg
	always @(posedge Clk) begin
		if (Rst == 1)
			State <= S_Wait;
		else
			State <= StateNext;
	end

	// CombLogic
	always @(*) begin
		case(State)
			S_Wait: begin
				U <= 0;
				if (Start == 1)
					StateNext <= S_Start;
				else
					StateNext <= S_Wait;
			end
			S_Start: begin
				U <= 0;
				// if (R & ~B & ~G == 1'b1)
				if (R == 1 && B == 0 && G == 0)
					StateNext <= S_Red1;
				// else if ((B | G) == 1'b1) StateNext <= S_Wait;
				else if (R == 0 && B == 0 && G == 0)
					StateNext <= S_Start;
				else
					StateNext <= S_Wait;
			end
			S_Red1: begin
				U <= 0;
				if (R == 0 && B == 1 && G == 0)
					StateNext <= S_Blue;
				else if (R == 0 && B == 0 && G == 0)
					StateNext <= S_Red1;
				else
					StateNext <= S_Wait;
			end
			S_Blue: begin
				U <= 0;
				if (R == 0 && B == 0 && G == 1)
					StateNext <= S_Green;
				else if (R == 0 && B == 0 && G == 0)
					StateNext <= S_Blue;
				else
					StateNext <= S_Wait;
			end
			S_Green: begin
				U <= 0;
				if (R == 1 && B == 0 && G == 0)
					StateNext <= S_Red2;
				else if (R == 0 && B == 0 && G == 0)
					StateNext <= S_Green;
				else
					StateNext <= S_Wait;
			end
			S_Red2: begin
				U <= 1;
				StateNext <= S_Wait;
			end
			default: begin
				U <= 0;
				StateNext <= S_Wait;
			end
		endcase
	end
endmodule