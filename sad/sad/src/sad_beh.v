// ***********************************************************************
// TITLE       : SAD Behavioral Model   
// AUTHOR      : Yoonjin Kim 
// AFFILIATION : Dept. of CS, Sookmyung Women's University 
// DESCRIPTION : SAD One-procedure model                     
// ***********************************************************************
`timescale 1 ns/1 ns
`define A_WIDTH 8
`define D_WIDTH 8

module SAD(Go, A_Addr, A_Data, 
           B_Addr, B_Data, RW, En,
           Done, SAD_Out, Clk, Rst);

   input Go;
   input [(`D_WIDTH-1):0] A_Data, B_Data;
   output reg [(`A_WIDTH-1):0] A_Addr, B_Addr;
   output reg RW, En, Done; 
   output reg [31:0] SAD_Out;
   input Clk, Rst;

   parameter S0 = 3'b000, S1 = 3'b001,
             S2 = 3'b010, S3a = 3'b011, 
	     S3 = 3'b100, S4 = 3'b101;

   reg [2:0] State;
   reg [31:0] Sum; 
   integer I;

   function [(`D_WIDTH-1):0] ABSDiff;
      input [(`D_WIDTH-1):0] A;
      input [(`D_WIDTH-1):0] B;
      begin
         if (A>B) ABSDiff = A - B;
         else ABSDiff = B - A;
      end
   endfunction

 always @(posedge Clk) begin
      if (Rst==1) begin
         A_Addr <= {`A_WIDTH{1'b0}};
         B_Addr <= {`A_WIDTH{1'b0}};
         RW <= 1'b0;
         En <= 1'b0;
	 Done <= 1'b0;
         State <= S0;
         Sum <= 32'b0;
         SAD_Out <= 32'b0;
         I <= 0;
      end
      else begin
           A_Addr <= {`A_WIDTH{1'b0}};
           B_Addr <= {`A_WIDTH{1'b0}};
	   RW <= 1'b0;
           En <= 1'b0;
	   Done <= 1'b0;
           SAD_Out <= 32'b0;
	   
	   case (State)
                S0: begin
                    if (Go==1'b1)
                      State <= S1;
                    else
                      State <= S0;
                    end
                S1: begin
                    Sum <= 32'b0;
                    I <= 0;
                    State <= S2;
                    end
                S2: begin
		    if (I<256) 
		       begin
                       	 State <= S3a;
                       	 A_Addr <= I;
                       	 B_Addr <= I;
              	       	 RW <= 1'b0;
		       	 En <= 1'b1; 
		       end 
                    else
                       State <= S4;
                    end
		S3a: 
	            State <= S3;
            	S3: begin
               	    Sum <= Sum +
                    ABSDiff(A_Data, B_Data);
               	    I <= I + 1;
               	    State <= S2;
                    end
            	S4: begin
               	    SAD_Out <= Sum;
                    Done <= 1'b1;
		    State <= S0;
            	    end
            endcase
      end
   end


endmodule
