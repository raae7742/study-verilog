`timescale 1 ns/1 ns

module MuxGate(A, B, C, D, S1, S0, Out);

	input A, B, C, D;
	input S1, S0;

	output Out;

	wire N1, N2, N3, N4, N5, N6;

	not Inv_1(N2, S1);
	not Inv_0(N1, S0);
	and And_1(N3, A, N2, N1);
	and And_2(N4, B, N2, S0);
	and And_3(N5, C, S1, N1);
	and And_4(N6, D, S1, S0);
	or Or_1(Out, N3, N4, N5, N6);	

endmodule