`timescale 1 ns/1 ns
`define D_WIDTH 8
`define A_WIDTH 8
`define ITR 64

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

	reg [3:0] State, StateNext;
	
	// Shared variables
	reg Rem_zero;
	reg Val_lt, Val_inc, Val_ld, Val_clr;
	reg Result_ld;
	reg I_lt, I_inc, I_clr;
	reg J_lt, J_inc, J_clr;
	reg Cnt_lt, Cnt_inc, Cnt_clr;

	//Datapath variables
	reg [19:0] Val, ValNext;
	reg [6:0] I;	
	reg [2:0] J, Cnt;	

	// ------ Datapath Procedures ------ //
	// DP CombLogic
	always @ (Val_inc, Val, I, J, Cnt) begin
		Rem_zero <= ((Data%Val) == 0)?1'b1:1'b0;
		Val_lt <= (Val < 970200)?1'b1:1'b0;
		ValNext <= (Val_inc == 1'b1)?ValNext+1:19'b0000_0000_0000_0000_001;
		
		J_lt <= (J<3'b100)?1'b1:1'b0;
		I_lt <= (I<7'b1000000)?1'b1:1'b0;
		Cnt_lt <= (Cnt<=3'b011)?1'b1:1'b0;

		Addr <= (I<<2)+J;
	end

	// DP Regs
	always @(posedge Clk) begin
		if (Rst == 1'b1) begin
			Val <= 16'b0000_0000_0000_0000;
			Result <= 16'b0000_0000_0000_0000;
			J <= 3'b000;
			I <= 7'b0000_000;
			Cnt <= 3'b000;
		end
		else begin
			if(Val_ld == 1'b1) Val <= ValNext;
			else if(Val_clr == 1'b1) Val <= 0;
			
			if(Result_ld == 1'b1) Result <= Val;
	
			if(J_inc==1'b1) J<=J+3'b001;
			else if(J_clr==1'b1) J<=0;
	
			if(I_inc==1'b1) I<=I+7'b0000_001;
			else if(I_clr==1'b1) J<=0;
	
			if(Cnt_inc==1'b1) Cnt<=Cnt+3'b001;
			else if(Cnt_clr==1'b1) Cnt<=0;
		end
	end

	// ------ Controller Procedures ------ //
	// Ctrl CombLogic
	always @(Data, Go, Val_lt, Rem_zero, I_lt, J_lt, Cnt_lt) begin
		case (State)
			S0: begin
				I_clr <= 0;
				J_clr <= 0;
				StateNext <= (Go == 1'b1)?S1:S0;
			end
			S1: begin
				Val_clr<=1'b1;
				StateNext <= S2;
			end
			S2: begin
				StateNext <= (Val_lt == 1'b1)?S3:S11;			
			end
			S3: begin
				J_clr<=1'b1;
				Cnt_clr<=1'b1;
				StateNext <= S4;
			end
			S4: begin
				StateNext <= (J_lt == 1'b1)?S5:S9;
			end
			S5: begin
				Rw<=1'b0;
				En<=1'b1;
				StateNext <= S6;
			end
			S6: begin
				StateNext <= (Rem_zero == 1'b1)?S7:S8;
			end
			S7: begin
				Cnt_inc <= 1'b1;
				StateNext <= S8;
			end
			S8: begin
				J_inc<=1'b1;
				StateNext <= S4;
			end
			S9: begin
				StateNext <= (Cnt_lt == 1'b1)?S10:S11;
			end
			S10: begin
				Val_inc <= 1'b1;
				StateNext <= S2;
			end
			S11: begin
				Result_ld <= 1'b1;
				I_inc <= 1'b1;
				StateNext <= (I_lt == 1'b1)?S1:S0;
			end
		endcase	
	end

	// Ctrl Regs
	always @ (posedge Clk) begin
		if (Rst == 1'b1) begin
			State <= S0;
		end
		else
			State <= StateNext;
	end
endmodule
