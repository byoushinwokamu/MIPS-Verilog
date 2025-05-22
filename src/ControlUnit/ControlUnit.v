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
		.op0(op[5]), .op1(op[4]), .op2(op[3]),
		.op3(op[2]), .op4(op[1]), .op5(op[0]),
		.ft0(funct[5]), .ft1(funct[4]), .ft2(funct[3]),
		.ft3(funct[2]), .ft4(funct[1]), .ft5(funct[0])
	);

	ALUDecoder alud (
		.IsSyscall,
		.IsJR,
		.IsShamt,
		.ALUop,
		.op0(op[5]), .op1(op[4]), .op2(op[3]),
		.op3(op[2]), .op4(op[1]), .op5(op[0]),
		.ft0(funct[5]), .ft1(funct[4]), .ft2(funct[3]),
		.ft3(funct[2]), .ft4(funct[1]), .ft5(funct[0])
	);

	// Exception Handler
	and (IsCOP0, ~op[5], op[4], ~op[3], ~op[2], ~op[1], ~op[0]);

endmodule

module ControlUnit_tb;
	reg [5:0] op, funct;
	wire IsJAL, IsShamt, MemtoReg, RegWrite;
	wire BneOrBeq, ALUSrc, IsSyscall, ZeroExtend;
	wire MemRead, MemWrite, Jump, Branch, RegDst;
	wire IsJR, IsCOP0, ReadRs, ReadRt;
	wire [3:0] ALUop;

	ControlUnit inst (
		.IsJAL, .IsShamt, .MemtoReg, .RegWrite,
		.BneOrBeq, .ALUSrc, .IsSyscall, .ZeroExtend,
		.MemRead, .MemWrite, .Jump, .Branch, .RegDst,
		.IsJR, .IsCOP0, .ReadRs, .ReadRt,
		.ALUop,
		.op, .funct
	);

	task test;
		input [5:0] iop, ifunct;
		input [255:0] name;
		begin
			op = iop; funct = ifunct;
			#1;
			$display("[%s] op = 0x%02X, funct = 0x%02X", name, op, funct);
			$display("  RegWrite=%b, MemRead=%b, MemWrite=%b, ALUSrc=%b, Branch=%b, Jump=%b, RegDst=%b", 
								RegWrite, MemRead, MemWrite, ALUSrc, Branch, Jump, RegDst);
			$display("  ALUop = %b, IsJR=%b, IsJAL=%b, IsSyscall=%b, IsShamt=%b, IsCOP0=%b", 
								ALUop, IsJR, IsJAL, IsSyscall, IsShamt, IsCOP0);
			$display("----------------------------------------------------");
		end
	endtask

	initial begin
		$display("=== ControlUnit Test ===");

		test(6'b000000, 6'b100000, "add");        // R-type
		test(6'b000000, 6'b100010, "sub");
		test(6'b000000, 6'b001000, "jr");
		test(6'b000000, 6'b001100, "syscall");

		test(6'b001000, 6'bxxxxxx, "addi");       // I-type
		test(6'b100011, 6'bxxxxxx, "lw");
		test(6'b101011, 6'bxxxxxx, "sw");
		test(6'b000100, 6'bxxxxxx, "beq");
		test(6'b000101, 6'bxxxxxx, "bne");

		test(6'b000010, 6'bxxxxxx, "j");
		test(6'b000011, 6'bxxxxxx, "jal");

		test(6'b010000, 6'b000000, "mtc0");       // COP0 test
		test(6'b010000, 6'b011000, "eret");

		$display("=== Done ===");
		#10 $finish;
	end

endmodule
