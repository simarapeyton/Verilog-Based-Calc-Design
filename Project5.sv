//loadA= ~sw9 & ~sw8
//loadB= sw8
//Quotient= sw9 
//Remainder = sw9 & sw8

//start = key1
//reset = key0

module Project5
(
input LoadALower,LoadAUpper,LoadB,Start,CLK,Reset,
input [7:0] in,
input [1:0] select,


output Done,
output [0:6] seg,
output [3:0]cat,
output [9:0] LEDR

);

wire [15:0] DividendTotalReg;
wire [7:0] DividendLowerReg, DividendUpperReg;
wire [7:0] DivisorReg;
wire[7:0] QuotientOut,RemainderOut,Quotient,Remainder;
wire [7:0] Result;

assign LEDR[9]=Start;
assign LEDR[8] = Done;
assign LEDR[7:0]=Quotient;


NbitRegisterSV #(8)LoadDividendUpperBits
(
	.D(in) ,	// input [N-1:0] D_sig
	.CLK(LoadAUpper) ,	// input  CLK_sig
	.CLR(Reset) ,	// input  CLR_sig
	.Q(DividendUpperReg) 	// output [N-1:0] Q_sig
);

NbitRegisterSV #(8)LoadDividendLowerBits
(
	.D(in) ,	// input [N-1:0] D_sig
	.CLK(LoadALower) ,	// input  CLK_sig
	.CLR(Reset) ,	// input  CLR_sig
	.Q(DividendLowerReg) 	// output [N-1:0] Q_sig
);

NbitRegisterSV #(16)LoadDividendTotalBits
(
	.D({DividendUpperReg,DividendLowerReg}) ,	// input [N-1:0] D_sig
	.CLK(CLK) ,	// input  CLK_sig
	.CLR(Reset) ,	// input  CLR_sig
	.Q(DividendTotalReg) 	// output [N-1:0] Q_sig
);


NbitRegisterSV #(8)LoadDivisor
(
	.D(in[7:0]) ,	// input [N-1:0] D_sig
	.CLK(LoadB) ,	// input  CLK_sig
	.CLR(Reset) ,	// input  CLR_sig
	.Q(DivisorReg) 	// output [N-1:0] Q_sig
);


EightBitDivder EightBitDivder_inst
(
	.Dividend(DividendTotalReg) ,	// input [15:0] Dividend_sig
	.Divisor(DivisorReg) ,	// input [7:0] Divisor_sig
	.Quotient(Quotient) ,	// output [7:0] Quotient_sig
	.Remainder(Remainder) ,	// output [7:0] Remainder_sig
	.CLOCK(CLK) ,	// input  CLOCK_sig
	.START(Start) ,	// input  START_sig
	.DONE(Done) 	// output  DONE_sig
);
/*
EightBitSIGNEDDivider EightBitDivder_inst
(
	.Dividend(DividendTotalReg) ,	// input [15:0] Dividend_sig
	.Divisor(DivisorReg) ,	// input [7:0] Divisor_sig
	.Quotient(Quotient) ,	// output [7:0] Quotient_sig
	.Remainder(Remainder) ,	// output [7:0] Remainder_sig
	.CLOCK(CLK) ,	// input  CLOCK_sig
	.START(Start) ,	// input  START_sig
	.DONE(Done) 	// output  DONE_sig
);
*/
NbitRegisterSV #(8) QuotientReg
(
	.D(Quotient) ,	// input [N-1:0] D_sig
	.CLK(Done) ,	// input  CLK_sig
	.CLR(Start) ,	// input  CLR_sig
	.Q(QuotientOut) 	// output CarryOut, OVR, ZERO, NEG
);

NbitRegisterSV #(8) RemainderReg
(
	.D(Remainder) ,	// input [N-1:0] D_sig 
	.CLK(Done) ,	// input  CLK_sig
	.CLR(Start) ,	// input  CLR_sig
	.Q(RemainderOut) 	// output CarryOut, OVR, ZERO, NEG
);


four2one #(16) four2one_inst
(
	.A(select[0]) ,	// input  A_sig
	.B(select[1]) ,	// input  B_sig
	.D0(DividendTotalReg) ,	// input [N-1:0] D0_sig
	.D1(DivisorReg) ,	// input [N-1:0] D1_sig
	.D2(QuotientOut) ,	// input [N-1:0] D2_sig
	.D3(RemainderOut) ,	// input [N-1:0] D3_sig
	.Y(Result) 	// output [N-1:0] Y_sig
);

Project2DISPLAY DISPLAYFinal
(
	.clk(CLK) ,	// input  clk_sig
	.reset(Reset) ,	// input  reset_sig
	.data(Result) ,	// input [7:0] data_sig
	.cat(cat) ,	// output [3:0] cat_sig
	.seg(seg) 	// output [0:6] seg_sig
);

endmodule

