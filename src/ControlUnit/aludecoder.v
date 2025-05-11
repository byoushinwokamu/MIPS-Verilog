module ALUDecoder(
	output IsSyscall,
	output IsJR,
	output IsShamt,
	output [3:0] ALUop,
	input ft0, ft1, ft2, ft3, ft4, ft5,
	input op0, op1, op2, op3, op4, op5
);
	wire IsSpecial;
	nor (
		IsSpecial, op0, op1, op2, op3, op4, op5
	);

	wire [3:0] aop_ft;
	wire jr_ft, sc_ft, sh_ft;
	ALUftDecoder ftd (
		.ALU0(aop_ft[3]), .ALU1(aop_ft[2]),
		.ALU2(aop_ft[1]), .ALU3(aop_ft[0]),
		.IsJR(jr_ft), .IsSyscall(sc_ft), .IsShamt(sh_ft),
		// .ft0(ft5), .ft1(ft4), .ft2(ft3), .ft3(ft2), .ft4(ft1), .ft5(ft0)
		.ft0, .ft1, .ft2, .ft3, .ft4, .ft5
	);

	wire [3:0] aop_op;
	ALUopDecoder opd (
		.ALUop0(aop_op[3]), .ALUop1(aop_op[2]),
		.ALUop2(aop_op[1]), .ALUop3(aop_op[0]),
		// .op0(op5), .op1(op4), .op2(op3), .op3(op2), .op4(op1), .op5(op0)
		.op0, .op1, .op2, .op3, .op4, .op5
	);

	// Multiplexing
	assign IsSyscall = IsSpecial ? sc_ft  : 1'b0;
	assign IsJR      = IsSpecial ? jr_ft  : 1'b0;
	assign IsShamt   = IsSpecial ? sh_ft  : 1'b0;
	assign ALUop     = IsSpecial ? aop_ft : aop_op;

endmodule
