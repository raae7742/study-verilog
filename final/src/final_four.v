`timescale 1 ns/1 ns
`define D_WIDTH 8
`define A_WIDTH 8
`define ITR 64

module FINAL_FOUR(Go, Addr, Data, 
				Rw, En, Done, Result, Rst, Clk);

	input Go;
	input [(`D_WIDTH-1):0] Data;
	output reg [(`A_WIDTH-1):0] Addr;
	output reg Rw, En, Done;
	output [19:0] Result;
	input Clk, Rst;

	parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011,
						S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111,
						S8 = 4'b1000, S9 = 4'b1001, S10 = 4'b1010, S11 = 4'b1011;

	reg [3:0] State, StateNext;
	
	// Shared variables
	reg Rem_zero;
	reg Val_lt, Val_ld, Val_sel;
	reg I_lt, I_inc, I_clr;
	reg J_lt, J_inc, J_clr;
	reg Cnt_lt, Cnt_inc, Cnt_clr;

	//Datapath variables
	reg [19:0] Val, ValNext;
	reg [6:0] I;	
	reg [2:0] J, Cnt;	
	reg [(`A_WIDTH-1):0] AddrNext;
		
	// ------ Datapath Procedures ------ //
	// DP CombLogic
	always @ (Data, Val_sel, Val, I, J, Cnt) begin
		Rem_zero <= (Val%Data==0)? 1'b1:1'b0;	
		Val_lt <= (Val < 20'd970200)?1'b1:1'b0;
		ValNext <= (Val_sel == 1'b1)?20'd1:Val+1;
		
		J_lt <= (J<3'b100)?1'b1:1'b0;
		I_lt <= (I<`ITR)?1'b1:1'b0;
		Cnt_lt <= (Cnt<3'b011)?1'b1:1'b0;
		Addr <= ((I*4)+J);
	end

	// DP Regs
	always @(posedge Clk) begin
		if (Rst == 1'b1) begin
			Val <= 20'b0000_0000_0000_0000_0000;
			J <= 3'b000;
			I <= 7'b0000_000;
			Cnt <= 3'b000;
		end
		else begin
			if(Val_ld == 1'b1) Val <= ValNext;

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
	always @(State, Data, Go, Val_lt, Rem_zero, I_lt, J_lt, Cnt_lt) begin
		Rw <= 1'b0;
		En <= 1'b0;
		Done <= 1'b0;
		I_clr <= 0;
		I_inc <= 0;
		J_clr <= 0;
		J_inc <= 0;
		Val_ld <= 0;
		Val_sel <= 0;
		Cnt_clr <= 0;
		Cnt_inc <= 0;
		
		case (State)
			S0: begin
				I_clr <= 1;
				J_clr <= 1;
				StateNext <= (Go == 1'b1)?S1:S0;
			end
			S1: begin
				Val_sel<=1'b1;
				Val_ld<=1'b1;
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
				Val_sel<=0;
				Val_ld<=1'b1;
				StateNext <= S2;
			end
			S11: begin
				I_inc <= 1'b1;
				Done <= 1'b1;
				StateNext = (I_lt == 1'b1)?S1:S0;
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

	assign Result = Val;

endmodule
