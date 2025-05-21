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

module OPDecoder_tb;
    reg op0, op1, op2, op3, op4, op5;
    wire MemRead, MemWrite, ALUSrc, Jump, MemtoReg;
    wire Branch, RegDst, RegWrite, BneBeq, IsJAL, ZeroExtend;

    OPDecoder inst (
        .MemRead, .MemWrite, .ALUSrc, .Jump, .MemtoReg,
        .Branch, .RegDst, .RegWrite, .BneBeq, .IsJAL, .ZeroExtend,
        .op0, .op1, .op2, .op3, .op4, .op5
    );

    task test_opcode;
        input [5:0] opcode;
        input [10:0] expected;
        begin
            {op0, op1, op2, op3, op4, op5} = opcode;

            #1; // propagation delay

            $display("opcode = %b -> MemRead  = %b (exp %b)", opcode, MemRead, expected[10]);
            $display("                   MemWrite = %b (exp %b)", MemWrite, expected[9]);
            $display("                   ALUSrc   = %b (exp %b)", ALUSrc, expected[8]);
            $display("                   Jump     = %b (exp %b)", Jump, expected[7]);
            $display("                   MemtoReg = %b (exp %b)", MemtoReg, expected[6]);
            $display("                   Branch   = %b (exp %b)", Branch, expected[5]);
            $display("                   RegDst   = %b (exp %b)", RegDst, expected[4]);
            $display("                   RegWrite = %b (exp %b)", RegWrite, expected[3]);
            $display("                   BneBeq   = %b (exp %b)", BneBeq, expected[2]);
            $display("                   IsJAL    = %b (exp %b)", IsJAL, expected[1]);
            $display("                   ZeroExt  = %b (exp %b)", ZeroExtend, expected[0]);
            $display("------------------------");
        end
    endtask

    initial begin
        $display("=== OPDecoder Test Start ===");

        // opcode 100011 (lw)
        test_opcode(6'b100011, 11'b1_0_1_0_1_0_0_1_0_0_0);  // MemRead, ALUSrc, MemtoReg, RegWrite

        // opcode 101011 (sw)
        test_opcode(6'b101011, 11'b0_1_1_0_0_0_0_0_0_0_0);  // MemWrite, ALUSrc

        // opcode 000100 (beq)
        test_opcode(6'b000100, 11'b0_0_0_0_0_1_0_0_1_0_0);  // Branch, BneBeq

        // opcode 000101 (bne)
        test_opcode(6'b000101, 11'b0_0_0_0_0_1_0_0_1_0_0);  // Branch, BneBeq

        // opcode 001000 (addi)
        test_opcode(6'b001000, 11'b0_0_1_0_0_0_0_1_0_0_0);  // ALUSrc, RegWrite

        // opcode 000011 (jal)
        test_opcode(6'b000011, 11'b0_0_0_1_0_0_0_1_0_1_0);  // Jump, RegWrite, IsJAL

        $display("=== OPDecoder Test Done ===");
        #10 $finish;
    end

endmodule