module Eight2one #(parameter N = 8)
(
	input [N-1:0]A,B, //declare select inputs
	output [N-1:0] Y, //declare data outputs
	input S				//select signal
);

	assign Y=(S==0) ? A:B;
endmodule
