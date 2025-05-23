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
	output ReadRs,
	output ReadRt,
	input [5:0] op,
	input [5:0] ft
);
	// MemRead
	and (MemRead, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);

	// MemWrite
	and (MemWrite, op[5], ~op[4], op[3], ~op[2], op[1], op[0]);

	// ALUSrc
	wire was [1:8];
	and (was[1], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (was[2], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (was[3], op[5], ~op[4], op[3], ~op[2], op[1], op[0]);
	and (was[4], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
	and (was[5], ~op[5], ~op[4], op[3], op[2], ~op[1], op[0]);
	and (was[6], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
	and (was[7], ~op[5], ~op[4], op[3], ~op[2], ~op[1], op[0]);
	and (was[8], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	or (
		ALUSrc, was[1], was[2], was[3], was[4],
		was[5], was[6], was[7], was[8]
	);

	// Jump
	wire wj [1:2];
	and (wj[1], ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0]);
	and (wj[2], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	or (Jump, wj[1], wj[2]);

	// MemtoReg
	and (MemtoReg, op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);

	// Branch
	wire wb [1:2];
	and (wb[1], ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);
	and (wb[2], ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);
	or (Branch, wb[1], wb[2]);

	// RegDst
	and (RegDst, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);

	// RegWrite
	wire wrw [1:10];
	and (wrw[1], ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	and (wrw[2], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wrw[3], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wrw[4], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
	and (wrw[5], ~op[5], ~op[4], op[3], op[2], ~op[1], op[0]);
	and (wrw[6], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
	and (wrw[7], ~op[5], ~op[4], op[3], ~op[2], ~op[1], op[0]);
	and (wrw[8], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wrw[9], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wrw[10], ~op[5], op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	or (
		RegWrite, wrw[1], wrw[2], wrw[3], wrw[4], wrw[5],
		wrw[6], wrw[7], wrw[8], wrw[9], wrw[10] 
	);

	// BneBeq
	and (BneBeq, ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);

	// IsJAL
	and (IsJAL, ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);

	// ZeroExtend
	wire wze [1:2];
	and (wze[1], ~op[5], ~op[4], op[3], op[2], ~op[1]);
	and (wze[2], ~op[5], ~op[4], op[3], op[2], op[1], ~op[0]);
	or (ZeroExtend, wze[1], wze[2]);

	// ReadRs
	wire wrr [1:10];
	wire wrrf [1:9];
	wire wrrf_or;

	and (wrr[1], ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], wrrf_or);
	or (
		wrrf_or, wrrf[1], wrrf[2], wrrf[3], wrrf[4], wrrf[5], 
		wrrf[6], wrrf[7], wrrf[8], wrrf[9]
	);
	and (wrrf[1], ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1], ~ft[0]);
	and (wrrf[2], ft[5], ~ft[4], ~ft[3], ft[2], ~ft[1], ~ft[0]);
	and (wrrf[3], ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1], ft[0]);
	and (wrrf[4], ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wrrf[5], ft[5], ~ft[4], ~ft[3], ft[2], ~ft[1], ft[0]);
	and (wrrf[6], ft[5], ~ft[4], ~ft[3], ft[2], ft[1], ft[0]);
	and (wrrf[7], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wrrf[8], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ft[0]);
	and (wrrf[9], ~ft[5], ~ft[4], ft[3], ~ft[2], ~ft[1], ~ft[0]);

	and (wrr[2], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wrr[3], ~op[5], ~op[4], op[3], ~op[2], ~op[1], op[0]);
	and (wrr[4], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
	and (wrr[5], ~op[5], ~op[4], op[3], op[2], ~op[1], op[0]);
	and (wrr[6], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wrr[7], ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);
	and (wrr[8], ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);
	and (wrr[9], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
	and (wrr[10], op[5], ~op[4], op[3], ~op[2], op[1], op[0]);

	or (
		ReadRs, wrr[1], wrr[2], wrr[3], wrr[4], wrr[5],
		wrr[6], wrr[7], wrr[8], wrr[9], wrr[10]
	);

	// ReadRt
	wire wrt [1:5];
	wire wrtf [1:11];
	wire wrtf_or;

	and (wrt[1], ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], wrtf_or);
	or (
		wrtf_or, wrtf[1], wrtf[2], wrtf[3], wrtf[4], wrtf[5],
		wrtf[6], wrtf[7], wrtf[8], wrtf[9], wrtf[10], wrtf[11]
	);
	and (wrtf[1], ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1], ~ft[0]);
	and (wrtf[2], ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1], ft[0]);
	and (wrtf[3], ft[5], ~ft[4], ~ft[3], ft[2], ~ft[1], ~ft[0]);
	and (wrtf[4], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1], ~ft[0]);
	and (wrtf[5], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ft[0]);
	and (wrtf[6], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wrtf[7], ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wrtf[8], ft[5], ~ft[4], ~ft[3], ft[2], ~ft[1], ft[0]);
	and (wrtf[9], ft[5], ~ft[4], ~ft[3], ft[2], ft[1], ft[0]);
	and (wrtf[10], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wrtf[11], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ft[0]);

	and (wrt[2], ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);
	and (wrt[3], ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);
	and (wrt[4], ~op[5], op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	and (wrt[5], op[5], ~op[4], op[3], ~op[2], op[1], op[0]);

	or (
		ReadRt, wrt[1], wrt[2],
		wrt[3], wrt[4], wrt[5]
	);

endmodule

module OPDecoder_tb;
    reg [5:0] op;
    wire MemRead, MemWrite, ALUSrc, Jump, MemtoReg;
    wire Branch, RegDst, RegWrite, BneBeq, IsJAL, ZeroExtend;

    OPDecoder inst (
        .MemRead, .MemWrite, .ALUSrc, .Jump, .MemtoReg,
        .Branch, .RegDst, .RegWrite, .BneBeq, .IsJAL, .ZeroExtend,
        .op
    );

    task test_opcode;
        input [5:0] opcode;
        input [10:0] expected;
        begin
            op = opcode;

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