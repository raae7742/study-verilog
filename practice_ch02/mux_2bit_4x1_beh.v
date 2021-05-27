`timescale 1 ns/1 ns

module MuxBeh(A1, A0, B1, B0, C1, C0, D1, D0, S1, S0, Out1, Out0);

   input A1, A0, B1, B0, C1, C0, D1, D0;
   input S1, S0;

   output Out1, Out0;
   reg Out1, Out0;

   always @ (*)
   begin
     if(S1 == 0 && S0 == 0)
	   begin
		   Out1 <= A0;
		   Out0 <= A1;
	   end
     else if(S1 == 0 && S0 == 1)
	   begin
      		   Out1 <= B1;
		   Out0 <= B0;
	   end
     else if(S1 == 1 && S0 == 0)
	   begin
		   Out1 <= C1;
		   Out0 <= C0;
	   end
     else if(S1 == 1 && S0 == 1)
	   begin
		   Out1 <= D1;
		   Out0 <= D0;
	   end
   end

endmodule

