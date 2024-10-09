module CLKLadder #(parameter N = 4)
(
input COUNT, CLEAR,
output logic [N-1:0] y // y is defined as a register
);
always_ff @ (posedge COUNT, negedge CLEAR)
if (CLEAR==1'b0) y <= 0; // y is loaded with all 0's
else y <= y + 1'b1; // y is incremented
endmodule
