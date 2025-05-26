module ControlUnit (
	output IsJAL, IsShamt, MemtoReg, RegWrite,
	output BneOrBeq, ALUSrc, IsSyscall, ZeroExtend,
	output MemRead, MemWrite, Jump, Branch, RegDst,
	output IsJR, IsCOP0, ReadRs, ReadRt,
	output [3:0] ALUop,
	input [5:0] op,
	input [5:0] funct
);

	OPDecoder opd (
		.MemRead,
		.MemWrite,
		.ALUSrc,
		.Jump,
		.MemtoReg,
		.Branch,
		.RegDst,
		.RegWrite,
		.BneBeq(BneOrBeq),
		.IsJAL,
		.ZeroExtend,
		.ReadRs,
		.ReadRt,
		.op,
		.ft(funct)
	);

	ALUDecoder alud (
		.IsSyscall,
		.IsJR,
		.IsShamt,
		.ALUop,
		.op,
		.ft(funct)
	);

	// Exception Handler
	and (IsCOP0, ~op[5], op[4], ~op[3], ~op[2], ~op[1], ~op[0]);

endmodule

`timescale 1ns/1ps

module tb_ControlUnit;

    reg [5:0] op, funct;
    wire IsJAL, IsShamt, MemtoReg, RegWrite;
    wire BneOrBeq, ALUSrc, IsSyscall, ZeroExtend;
    wire MemRead, MemWrite, Jump, Branch, RegDst;
    wire IsJR, IsCOP0, ReadRs, ReadRt;
    wire [3:0] ALUop;

    ControlUnit dut (
        .IsJAL, .IsShamt, .MemtoReg, .RegWrite,
        .BneOrBeq, .ALUSrc, .IsSyscall, .ZeroExtend,
        .MemRead, .MemWrite, .Jump, .Branch, .RegDst,
        .IsJR, .IsCOP0, .ReadRs, .ReadRt,
        .ALUop,
        .op, .funct
    );

    task test_instruction;
        input [5:0] i_op;
        input [5:0] i_fun;
        input [8*9:1] name;

        input exp_IsJAL, exp_IsShamt, exp_MemtoReg, exp_RegWrite;
        input exp_BneOrBeq, exp_ALUSrc, exp_IsSyscall, exp_ZeroExtend;
        input exp_MemRead, exp_MemWrite, exp_Jump, exp_Branch, exp_RegDst;
        input exp_IsJR, exp_IsCOP0, exp_ReadRs, exp_ReadRt;
        input [3:0] exp_ALUop;

        begin
            op = i_op;
            funct = i_fun;
            #1;

            $display("==== Instruction: %s ====", name);
            $display("ALUop: %b (expected %b) %s", ALUop, exp_ALUop, (ALUop === exp_ALUop) ? "OK      " : "MISMATCH");
            $display("IsJAL: %b      (exp %b) %s", IsJAL, exp_IsJAL, (IsJAL === exp_IsJAL) ? "      OK" : "MISMATCH");
            $display("IsShamt: %b    (exp %b) %s", IsShamt, exp_IsShamt, (IsShamt === exp_IsShamt) ? "      OK" : "MISMATCH");
            $display("MemtoReg: %b   (exp %b) %s", MemtoReg, exp_MemtoReg, (MemtoReg === exp_MemtoReg) ? "      OK" : "MISMATCH");
            $display("RegWrite: %b   (exp %b) %s", RegWrite, exp_RegWrite, (RegWrite === exp_RegWrite) ? "      OK" : "MISMATCH");
            $display("");
            $display("BneOrBeq: %b   (exp %b) %s", BneOrBeq, exp_BneOrBeq, (BneOrBeq === exp_BneOrBeq) ? "      OK" : "MISMATCH");
            $display("ALUSrc: %b     (exp %b) %s", ALUSrc, exp_ALUSrc, (ALUSrc === exp_ALUSrc) ? "      OK" : "MISMATCH");
            $display("IsSyscall: %b  (exp %b) %s", IsSyscall, exp_IsSyscall, (IsSyscall === exp_IsSyscall) ? "      OK" : "MISMATCH");
            $display("ZeroExtend: %b (exp %b) %s", ZeroExtend, exp_ZeroExtend, (ZeroExtend === exp_ZeroExtend) ? "      OK" : "MISMATCH");
            $display("");
            $display("MemRead: %b    (exp %b) %s", MemRead, exp_MemRead, (MemRead === exp_MemRead) ? "      OK" : "MISMATCH");
            $display("MemWrite: %b   (exp %b) %s", MemWrite, exp_MemWrite, (MemWrite === exp_MemWrite) ? "      OK" : "MISMATCH");
            $display("Jump: %b       (exp %b) %s", Jump, exp_Jump, (Jump === exp_Jump) ? "      OK" : "MISMATCH");
            $display("Branch: %b     (exp %b) %s", Branch, exp_Branch, (Branch === exp_Branch) ? "      OK" : "MISMATCH");
            $display("");
            $display("RegDst: %b     (exp %b) %s", RegDst, exp_RegDst, (RegDst === exp_RegDst) ? "      OK" : "MISMATCH");
            $display("IsJR: %b       (exp %b) %s", IsJR, exp_IsJR, (IsJR === exp_IsJR) ? "      OK" : "MISMATCH");
            $display("IsCOP0: %b     (exp %b) %s", IsCOP0, exp_IsCOP0, (IsCOP0 === exp_IsCOP0) ? "      OK" : "MISMATCH");
            $display("ReadRs: %b     (exp %b) %s", ReadRs, exp_ReadRs, (ReadRs === exp_ReadRs) ? "      OK" : "MISMATCH");
            $display("ReadRt: %b     (exp %b) %s", ReadRt, exp_ReadRt, (ReadRt === exp_ReadRt) ? "      OK" : "MISMATCH");
            $display("");
        end
    endtask

    initial begin
        test_instruction(6'b000000, 6'b100000, "add",     0,0,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,1, 1, 4'd5);
        test_instruction(6'b001000, 6'b000000, "addi",    0,0,0,1, 0,1,0,0, 0,0,0,0, 0,0,0,1, 0, 4'd5);
        test_instruction(6'b001001, 6'b000000, "addiu",   0,0,0,1, 0,1,0,0, 0,0,0,0, 0,0,0,1, 0, 4'd5);
        test_instruction(6'b000000, 6'b100001, "addu",    0,0,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,1, 1, 4'd5);
        test_instruction(6'b000000, 6'b100100, "and",     0,0,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,1, 1, 4'd7);
        test_instruction(6'b001100, 6'b000000, "andi",    0,0,0,1, 0,1,0,1, 0,0,0,0, 0,0,0,1, 0, 4'd7);
        test_instruction(6'b000000, 6'b000000, "sll",     0,1,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1, 4'd0);
        test_instruction(6'b000000, 6'b000011, "sra",     0,1,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1, 4'd1);
        test_instruction(6'b000000, 6'b000010, "srl",     0,1,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,0, 1, 4'd2);
        test_instruction(6'b000000, 6'b100010, "sub",     0,0,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,1, 1, 4'd6);
        test_instruction(6'b000000, 6'b100101, "or",      0,0,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,1, 1, 4'd8);
        test_instruction(6'b001101, 6'b000000, "ori",     0,0,0,1, 0,1,0,1, 0,0,0,0, 0,0,0,1, 0, 4'd8);
        test_instruction(6'b000000, 6'b100111, "nor",     0,0,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,1, 1, 4'd10);
        test_instruction(6'b000000, 6'b101010, "slt",     0,0,0,1, 0,0,0,0, 0,0,0,0, 1,0,0,1, 1, 4'd11);
        test_instruction(6'b001010, 6'b000000, "slti",    0,0,0,1, 0,1,0,0, 0,0,0,0, 0,0,0,1, 0, 4'd11);
        test_instruction(6'b001011, 6'b000000, "sltu",    0,0,0,1, 0,1,0,0, 0,0,0,0, 0,0,1,0, 1, 4'd12); // opcode issue?
        test_instruction(6'b100011, 6'b000000, "lw",      0,0,1,1, 0,1,0,0, 1,0,0,0, 0,0,0,1, 0, 4'd5);
        test_instruction(6'b101011, 6'b000000, "sw",      0,0,0,0, 0,1,0,0, 0,1,0,0, 0,0,0,1, 1, 4'd5);
        test_instruction(6'b000100, 6'b000000, "beq",     0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 1, 4'd11); // opcode
        test_instruction(6'b000101, 6'b000000, "bne",     0,0,0,0, 1,0,0,0, 0,0,0,1, 0,0,0,1, 1, 4'd11);
        test_instruction(6'b000010, 6'b000000, "j",       0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0, 0, 4'd0); //op
        test_instruction(6'b000011, 6'b000000, "jal",     1,0,0,1, 0,0,0,0, 0,0,1,0, 0,0,0,0, 0, 4'd0); //op
        test_instruction(6'b000000, 6'b001000, "jr",      0,0,0,1, 0,0,0,0, 0,0,0,0, 1,1,0,1, 0, 4'd0);
        test_instruction(6'b000000, 6'b001100, "syscall", 0,0,0,1, 0,0,1,0, 0,0,0,0, 1,0,0,0, 0, 4'd0);
        test_instruction(6'b010000, 6'b000000, "mfc0",    0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,1,0, 1, 4'd5);
        test_instruction(6'b010000, 6'b000100, "mtc0",    0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,1,0, 1, 4'd5);
        test_instruction(6'b010000, 6'b011000, "eret",    0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,1,0, 1, 4'd0); //op

        $display("All tests completed.");
        $finish;
    end

endmodule