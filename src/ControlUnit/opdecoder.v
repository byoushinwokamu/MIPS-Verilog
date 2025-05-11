module OPDecoder (
	output MemRead,
	output MemWrite,
	output ALUSrc,
	output Jump,
	output MemtoReg,
	output Branch,
	output RegDst,
	output RegWrite,
	output BneBeq,
	output IsJAL,
	output ZeroExtend,
	input op0, op1, op2, op3, op4, op5
);
	// MemRead
	and (MemRead, op0, ~op1, ~op2, ~op3, op4, op5);

	// MemWrite
	and (MemWrite, op0, ~op1, op2, ~op3, op4, op5);

	// ALUSrc
	wire was [1:8];
	and (was[1], ~op0, ~op1, op2, ~op3, ~op4, ~op5);
	and (was[2], op0, ~op1, ~op2, ~op3, op4, op5);
	and (was[3], op0, ~op1, op2, ~op3, op4, op5);
	and (was[4], ~op0, ~op1, op2, op3, ~op4, ~op5);
	and (was[5], ~op0, ~op1, op2, op3, ~op4, op5);
	and (was[6], ~op0, ~op1, op2, ~op3, op4, ~op5);
	and (was[7], ~op0, ~op1, op2, ~op3, ~op4, op5);
	and (was[8], ~op0, ~op1, op2, ~op3, ~op4, ~op5);
	or (
		ALUSrc, was[1], was[2], was[3], was[4],
		was[5], was[6], was[7], was[8]
	);

	// Jump
	wire wj [1:2];
	and (wj[1], ~op0, ~op1, ~op2, ~op3, op4, ~op5);
	and (wj[2], ~op0, ~op1, ~op2, ~op3, op4, op5);
	or (Jump, wj[1], wj[2]);

	// MemtoReg
	and (MemtoReg, op0, ~op1, ~op2, ~op3, op4, op5);

	// Branch
	wire wb [1:2];
	and (wb[1], ~op0, ~op1, ~op2, op3, ~op4, op5);
	and (wb[2], ~op0, ~op1, ~op2, op3, ~op4, ~op5);
	or (Branch, wb[1], wb[2]);

	// RegDst
	and (RegDst, ~op0, ~op1, ~op2, ~op3, ~op4, ~op5);

	// RegWrite
	wire wrw [1:10];
	and (wrw[1], ~op0, ~op1, ~op2, ~op3, ~op4, ~op5);
	and (wrw[2], ~op0, ~op1, op2, ~op3, ~op4, ~op5);
	and (wrw[3], op0, ~op1, ~op2, ~op3, op4, op5);
	and (wrw[4], ~op0, ~op1, op2, op3, ~op4, ~op5);
	and (wrw[5], ~op0, ~op1, op2, op3, ~op4, op5);
	and (wrw[6], ~op0, ~op1, op2, ~op3, op4, ~op5);
	and (wrw[7], ~op0, ~op1, op2, ~op3, ~op4, op5);
	and (wrw[8], ~op0, ~op1, op2, ~op3, ~op4, ~op5);
	and (wrw[9], ~op0, ~op1, ~op2, ~op3, op4, op5);
	and (wrw[10], ~op0, op1, ~op2, ~op3, ~op4, ~op5);
	or (
		RegWrite, wrw[1], wrw[2], wrw[3], wrw[4], wrw[5],
		wrw[6], wrw[7], wrw[8], wrw[9], wrw[10] 
	);

	// BneBeq
	and (BneBeq, ~op0, ~op1, ~op2, op3, ~op4, op5);

	// IsJAL
	and (IsJAL, ~op0, ~op1, ~op2, ~op3, op4, op5);

	// ZeroExtend
	wire wze [1:2];
	and (wze[1], ~op0, ~op1, op2, op3, ~op4);
	and (wze[2], ~op0, ~op1, op2, op3, op4, ~op5);
	or (ZeroExtend, wze[1], wze[2]);

	// ReadRs

endmodule
