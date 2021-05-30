// ***********************************************************************
// TITLE       : Testbench for SAD_Top   
// AUTHOR      : Yoonjin Kim 
// AFFILIATION : Dept. of CS, Sookmyung Women's University 
// DESCRIPTION : Testbench simulating SAD_Top Module                     
// ***********************************************************************
`timescale 1 ns/1 ns
`define A_WIDTH 8
`define D_WIDTH 8
`define ITR 1
module Testbench();
   reg  	           Go_t_s; 
   wire 	           Done_t_s; 
   wire [31:0]	           SAD_Out_t_s; 
   reg  	           Rst_Core_s; 
   reg  [31:0]  	   MA_di31_s; 
   reg  [31:0]             MB_di31_s;
   wire [(`D_WIDTH-1):0]   MA_di8_s;  //dummy port, not used!
   wire [(`D_WIDTH-1):0]   MB_di8_s;  //dummy port, not used!
   wire [31:0]             MA_do31_s; //dummy port, not used! 
   wire [31:0]             MB_do31_s; //dummy port, not used!
   reg  [(`A_WIDTH-3):0]   MA_Addr6_s; 
   reg  [(`A_WIDTH-3):0]   MB_Addr6_s;
   reg  	           MA_enb_s; 
   reg  	           MB_enb_s; 
   reg  	           MA_web_s; 
   reg  	           MB_web_s; 
   reg  	           Rst_M_s;
   reg  	           Clk_s;
   
   reg [31:0] A[0:(2**(`A_WIDTH-2)-1)];
   reg [31:0] B[0:(2**(`A_WIDTH-2)-1)];
   reg [31:0] Ref[0:(`ITR-1)];
   integer Index; 
   parameter ClkPeriod = 20;
   
  SAD_Top CompToTest(
      Go_t_s, 
      Done_t_s, 
      SAD_Out_t_s, 
      Rst_Core_s, 
      MA_di31_s, 
      MB_di31_s,
      MA_di8_s, 
      MB_di8_s, 
      MA_do31_s, 
      MB_do31_s, 
      MA_Addr6_s, 
      MB_Addr6_s,
      MA_enb_s, 
      MB_enb_s, 
      MA_web_s, 
      MB_web_s, 
      Rst_M_s,
      Clk_s
      );
	  
   // Clock Procedure
   always begin
      Clk_s <= 0; #(ClkPeriod/2);
      Clk_s <= 1; #(ClkPeriod/2);
   end

   // Initialize Arrays
   initial $readmemh("../sw/MemA.txt", A);
   initial $readmemh("../sw/MemB.txt", B);
   initial $readmemh("../sw/sw_result.txt", Ref);
  
   
   initial begin
      
     Rst_M_s <= 1; Rst_Core_s <= 1; Go_t_s <= 0; 	   
     MA_enb_s <= 1'b0; MB_enb_s <= 1'b0;
     MA_web_s <= 1'b0; MB_web_s <= 1'b0; 
     @(posedge Clk_s);
     
     Rst_M_s <= 0;
     @(posedge Clk_s);
     
     for(Index=0;Index<(2**(`A_WIDTH-2));Index=Index+1) begin 
          MA_enb_s <= 1'b1;
          MA_web_s <= 1'b1;
          MA_Addr6_s <= Index;
	  MA_di31_s <= A[Index];
          @(posedge Clk_s);
     end
     
     MA_enb_s <= 1'b0; 
     MA_web_s <= 1'b0; 
     @(posedge Clk_s);

      for(Index=0;Index<(2**(`A_WIDTH-2));Index=Index+1) begin 
          MB_enb_s <= 1'b1;
          MB_web_s <= 1'b1;
          MB_Addr6_s <= Index;
	  MB_di31_s <= B[Index];
          @(posedge Clk_s);
       end

     MB_enb_s <= 1'b0; 
     MB_web_s <= 1'b0; 
     @(posedge Clk_s);
	  
   //Running SAD-Core
      Rst_Core_s <= 0; Go_t_s <= 1;
      @(posedge Clk_s);
      
      Go_t_s <= 0;
      @(posedge Clk_s);
     
      for(Index=0;Index<`ITR;Index=Index+1) begin 
	while(Done_t_s != 1'b1) 
      	  @(posedge Clk_s);
      	
	  if (SAD_Out_t_s != Ref[Index]) 
         	$display("SAD failed with %x-- should equal to %x", SAD_Out_t_s, Ref[Index]);
      	  else 
	 	$display("SAD is %x that is equal to %x", SAD_Out_t_s, Ref[Index]);
	  @(posedge Clk_s);
      end 	
      $stop; 
   end
endmodule
