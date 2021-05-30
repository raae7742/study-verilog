// ***********************************************************************
// TITLE       : SAD_Top Module   
// AUTHOR      : Yoonjin Kim 
// AFFILIATION : Dept. of CS, Sookmyung Women's University 
// DESCRIPTION : Top module including SAD and Dual-Port SRAM                     
// ***********************************************************************

`timescale 1 ns/1 ns
`define A_WIDTH 8
`define D_WIDTH 8

module SAD_Top(Go_t, Done_t, SAD_Out_t, Rst_Core, MA_di31, MB_di31,
	       MA_di8, MB_di8, MA_do31, MB_do31, MA_Addr6, MB_Addr6,
	       MA_enb, MB_enb, MA_web, MB_web, Rst_M, Clk);
   
   //SAD_Core Interface 
   input Go_t;
   output Done_t;
   output [31:0] SAD_Out_t;
   input Rst_Core;
   
   //Dual-port SRAM Interface 
   input [31:0] MA_di31, MB_di31;
   input [7:0] MA_di8, MB_di8;  //dummy port, not used!
   output [31:0] MA_do31, MB_do31; //dummy port, not used!
   input [5:0] MA_Addr6, MB_Addr6;
   input MA_enb, MB_enb, MA_web, MB_web;
   input Rst_M;
   
   //Interface between SAD_Core and Dual_port SRAM
   wire [(`D_WIDTH-1):0] MA_do8, MB_do8;
   wire [(`A_WIDTH-1):0] MA_Addr8, MB_Addr8;
   wire M_ena, M_wea;
   
   //Common Interface 
   input Clk;
   
  
  SAD SAD_Core(Go_t, MA_Addr8, MA_do8,
               MB_Addr8, MB_do8, M_wea, M_ena,
               Done_t, SAD_Out_t, Clk, Rst_Core);
   
   dp_sram_coregen SADMemA(
	MA_Addr8,//addra,
	MA_Addr6,//addrb,
	Clk,//clka,
	Clk,//clkb,
	MA_di8,//dina,
	MA_di31,//dinb,
	MA_do8,//douta,
	MA_do31,//doutb,
	M_ena,//ena,
	MA_enb,//enb,
	Rst_M,//sinita,
	Rst_M,//sinitb,
	M_wea,//wea,
	MA_web);//web);
   
   dp_sram_coregen SADMemB(
	MB_Addr8,//addra,
	MB_Addr6,//addrb,
	Clk,//clka,
	Clk,//clkb,
	MB_di8,//dina,
	MB_di31,//dinb,
	MB_do8,//douta,
	MB_do31,//doutb,
	M_ena,//ena,
	MB_enb,//enb,
	Rst_M,//sinita,
	Rst_M,//sinitb,
	M_wea,//wea,
	MB_web);//web);

endmodule
