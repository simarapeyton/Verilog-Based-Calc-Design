module Project2DISPLAY
(
	input logic clk,reset,
	input [15:0]data,
	output logic [3:0] cat,
	output logic [0:6] seg
	//output logic [9:0]LEDR 
); 
logic OnOffOut;
logic [31:0] CounterClk;
logic [3:0] hex3,hex2,hex1,hex0;
logic [1:0]select;
logic [3:0] outBCD3, outBCD2,outBCD1,outBCD0, regOut;


//assign LEDR= CounterClk[31:22];

CLKLadder #(32) CLKLadder_inst
(
	.COUNT(clk) ,	// input  COUNT_sig
	.CLEAR(reset) ,	// input  CLEAR_sig
	.y(CounterClk) 	// output [N-1:0] y_sig
);



FSM FSM_inst
(
	.slow_clock(CounterClk[16]) ,	// input  slow_clock_sig mux rate CounterClk[17]speedOut
	.reset(reset) ,	// input  reset_sig
	.SEL(select) ,	// output [1:0] SEL_sig
	.CAT(cat) 	// output [3:0] CAT_sig
);


NbitRegisterSV #(16) NbitRegisterSV_inst
(
	//.D({4'b0,4'b0,data[7:4],data[3:0]}) ,
	.D({data[15:12],data[11:8],data[7:4],data[3:0]}) ,	// input [N-1:0] D_sig
	.CLK(CounterClk[22]) ,	// input  CLK_sig
	.CLR(reset) ,	// input  CLR_sig
	.Q({outBCD3,outBCD2,outBCD1,outBCD0}) 	// output [N-1:0] Q_sig
);
four2one #(4) four2one_inst
(
	.A(select[0]) ,	// input  A_sig
	.B(select[1]) ,	// input  B_sig
	.D0(outBCD0) ,	// input [N-1:0] D0_sig
	.D1(outBCD1) ,	// input [N-1:0] D1_sig
	.D2(outBCD2) ,	// input [N-1:0] D2_sig
	.D3(outBCD3) ,	// input [N-1:0] D3_sig
	.Y(regOut) 	// output [N-1:0] Y_sig
);

binary2seven binary2seven_inst
(
	.BIN(regOut) ,	// input [3:0] BIN_sig
	.SEV(seg) 	// output [6:0] SEV_sig
);



endmodule 