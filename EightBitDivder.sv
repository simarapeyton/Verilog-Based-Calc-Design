module EightBitDivder (
	input [15:0] Dividend,
	input [7:0] Divisor,
	output [7:0] Quotient,
	output [7:0] Remainder,
	input CLOCK,
	input START,
	output DONE
);
	wire [8:0] alu_out;
	wire alu_cy;
	wire [8:0] mux_out;
	wire [8:0] mux_in;	
	wire [8:0] R_out;
	wire [7:0] Q_out;
	wire [7:0] D_out;
	wire Rload;
	wire Qload;
	wire Dload;	
	wire Rshift;
	wire Qshift;
	wire AddSub;
	wire Qbit;
	assign Remainder = R_out[7:0];
	assign mux_in = {1'b0, Dividend[15:8]};
	assign Quotient = Q_out;
	
	Eight2one #(9) Mux1 (alu_out, mux_in, mux_out, Qload);
	shiftreg #(9) Rreg (mux_out, R_out, CLOCK, Rload, Rshift, Q_out[7]);
	shiftreg #(8) Qreg (Dividend[7:0], Q_out, CLOCK, Qload, Qshift, Qbit);
	shiftreg #(8) Dreg (Divisor, D_out, CLOCK, Dload, 1'b0, 1'b0);
	alu #(8) AdSb (R_out, D_out, alu_out, AddSub);
	dividerController DivCtrl (CLOCK, START, alu_out[8], AddSub, Dload, Rload, Qload, Rshift, Qshift, DONE, Qbit);
endmodule
