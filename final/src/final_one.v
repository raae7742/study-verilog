`timescale 1 ns/1 ns
`define D_WIDTH 8
`define A_WIDTH 8

module FINAL(Go, Addr, Data, 
				Rw, En, Done, Result, Rst, Clk);

	input Go;
	input [(`D_WIDTH-1):0] Data;
	output reg [(`A_WIDTH-1):0] Addr;
	output reg Rw, En, Done;
	output reg [19:0] Result;
	input Clk, Rst;

	parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011,
						S4 = 4'b0100, S5 = 4'b0101, S6a = 4'b0110, S6 = 4'b0111,
						S7 = 4'b1000, S8 = 4'b1001, S9 = 4'b1010, S10 = 4'b1011,
						S11 = 4'b1100;

	reg [3:0] State;
	reg [19:0] Val;
	reg [2:0] Cnt;
	integer J;

	always @(posedge Clk) begin
		if (Rst==1'b1) begin
			Addr <= {`A_WIDTH{1'b0}};
			Rw <= 1'b0;
			En <= 1'b0;
			Done <= 0;
			State <= S0;
			Result <= 20'b0;
			Val <= 20'b0;
			J <= 0;
			Cnt <= 3'b0;
		end
		else begin
			Addr <= {`A_WIDTH{1'b0}};
			Result <= 20'b0;
			Done <= 0;
			Rw <= 1'b0;
			En <= 1'b0;

			case (State)
				S0: begin
					J <= 0;
					Cnt <= 3'b0;
					Val <= 20'b0000_0000_0000_0000_0001;
					if (Go==1'b1)
						State <= S1;
					else
						State <= S0;
				end
				S1: begin
					J <= 0;
					Cnt <= 3'b0;
					Val <= 20'b0000_0000_0000_0000_0001;
					State <= S2;
				end
				S2: begin
					J <= 0;
					Cnt <= 3'b0;
					if (Val <= 20'd970200)
						State <= S3;
					else
						State <= S11;
				end
				S3: begin
					J <= 0;
					Cnt <= 3'b0;
					State <= S4;
				end
				S4: begin
					if (J<4)
						State <= S5;
					else
						State <= S9;
				end
				S5: begin
					State <= S6a;
					Addr <= J;
					Rw <= 1'b0;
					En <= 1'b1;
				end
				S6a:
					State <= S6;
				S6: begin
					if (Val%Data == 0)
						State <= S7;
					else
						State <= S8;
				end
				S7: begin
					Cnt <= Cnt+3'b001;
					State <= S8;
				end
				S8: begin
					J <= J+1;
					State <= S4;
				end
				S9: begin
					if (Cnt>=3'b011)
						State <= S11;
					else
						State <= S10;
				end
				S10: begin
					Val <= Val + 20'b0000_0000_0000_0000_0001;
					State <= S2;
				end
				S11: begin
					Result <= Val;
				  Done <= 1'b1;
					State <= S0;
				end
				default: begin
					State <= S0;
				end
			endcase
		end
	end
endmodule