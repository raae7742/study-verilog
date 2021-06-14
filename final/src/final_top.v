`timescale 1 ns/1 ns
`define A_WIDTH 8
`define D_WIDTH 8

module FINAL_Top(Go_t, Done_t, Result_t, Rst_Core, M_di32, M_di8,
									M_do32, M_Addr6, M_enb, M_web, Rst_M, Clk);

//FINAL_Core Interface
input Go_t;
output Done_t;
output [19:0] Result_t;
input Rst_Core;

//Dual-port SRAM Interface
input [31:0] M_di32;
input [7:0] M_di8;
output [31:0] M_do32;
input [5:0] M_Addr6;
input M_enb, M_web;
input Rst_M;

//Interface between FIANL_Core and Dual_port SRAM
wire [(`D_WIDTH-1):0] M_do8;
wire [(`A_WIDTH-1):0] M_Addr8;
wire M_ena, M_wea;

//Common Interface
input Clk;

FINAL FINAL_Core(Go_t, M_Addr8, M_do8, M_wea, M_ena, Done_t, Result_t, Rst_Core, Clk);

dp_sram_coregen FINALMem(
	M_Addr8,
	M_Addr6,
	Clk,
	Clk,
	M_di8,
	M_di32,
	M_do8,
	M_do32,
	M_ena,
	M_enb,
	Rst_M,
	Rst_M,
	M_wea,
	M_web);

endmodule