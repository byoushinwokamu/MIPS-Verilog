module ALU (result1, result2, OF, CF, Equal, sr, tg, ALUop);
	output [31:0] result1;
	output [31:0] result2;
	output OF, CF, Equal;
	input [31:0] sr;
	input [31:0] tg;
	input [3:0] ALUop;

	wire [31:0] res [15:0];
	wire [31:0] res2 [15:0];
	wire [1:0] OCF [15:0];
	ShiftLeftLogic sll (.res(res[0]), .tg(sr), .sh(tg[4:0]));
	ShiftRightArith sra (.res(res[1]), .tg(sr), .sh(tg[4:0]));
	ShiftRightLogic srl (.res(res[2]), .tg(sr), .sh(tg[4:0]));
	Mul mul (.res(res[3]), .cout(res2[3]), .sr, .tg, .cin(1'b0));
	Div div (.res(res[4]), .rem(res2[4]), .sr, .tg, .upper(1'b0));
	Add add (.res(res[5]), .CF(OCF[5][0]), .OF(OCF[5][1]), .sr, .tg, .cin(1'b0));
	Sub sub (.res(res[6]), .CF(OCF[6][0]), .OF(OCF[6][1]), .sr, .tg, .bin(1'b0));
	and andinst [31:0] (res[7], sr, tg);
	or orinst [31:0] (res[8], sr, tg);
	xor xorinst [31:0] (res[9], sr, tg);
	nor norinst [31:0] (res[10], sr, tg);
	wire wlt, wltu;
	LessThan lt (.lt(wlt), .sr, .tg);
	LessThanUnsigned ltu (.lt(wltu), .eq(Equal), .sr, .tg);
	assign res[11] = {31'b0, wlt};
	assign res[12] = {31'b0, wltu};

	assign result1 = res[ALUop];
	assign result2 = res2[ALUop];
	assign OF = OCF[ALUop][1];
	assign CF = OCF[ALUop][0];

endmodule
