`timescale 1 ns/1 ns

module MuxStr(A1, A0, B1, B0, C1, C0, D1, D0, S1, S0, Out1, Out0);
    
   input A1, A0, B1, B0, C1, C0, D1, D0, S1, S0;
   output Out1, Out0;

   MuxGate Mux1 (A0, B0, C0, D0, S1, S0, Out0);
   MuxGate Mux2 (A1, B1, C1, D1, S1, S0, Out1);

endmodule