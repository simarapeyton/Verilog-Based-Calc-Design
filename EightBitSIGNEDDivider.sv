module EightBitSIGNEDDivider (
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
	wire [15:0] DividendSIGNED;
	assign Remainder = R_out[7:0];
	assign mux_in = {1'b0, Dividend[15:8]};
	assign Quotient = Q_out;
	logic DividendReg, DivisorReg;
	always @(posedge CLOCK) 
		 if (Dividend[15] == 1) begin DividendSIGNED<=(Dividend^1)+1; DividendReg=1;end //if a 1 in MSB do 2s complement
		 else if (Divisor[7]==1) begin DivisorSIGNED<=(Divisor^1)+1; DivisorReg=1;end
		 else begin DivisorSIGNED<=Divisor; DividendSIGNED<=Dividend; end
		 
	always @(posedge CLOCK) 
		if(DividendReg^DivisorReg==1) begin Q_out<=(Q_out^1)+1; R_out[7:0]<=(R_out[7:0]^1)+1;	end //if a neg * a pos. do 2s complement
		
	Eight2one #(9) Mux1 (alu_out, mux_in, mux_out, Qload);
	shiftreg #(9) Rreg (mux_out, R_out, CLOCK, Rload, Rshift, Q_out[7]);
	shiftreg #(8) Qreg (DividendSIGNED[7:0], Q_out, CLOCK, Qload, Qshift, Qbit);
	shiftreg #(8) Dreg (DivisorSIGNED, D_out, CLOCK, Dload, 1'b0, 1'b0);
	alu #(8) AdSb (R_out, D_out, alu_out, AddSub);
	dividerController DivCtrl (CLOCK, START, alu_out[8], AddSub, Dload, Rload, Qload, Rshift, Qshift, DONE, Qbit);
endmodule
