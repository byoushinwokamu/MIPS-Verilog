module SingleCycleCPU #(
	parameter INIT_FILE1 = "program1.hex", INIT_FILE2 = "program2.hex"
) (
	output [31:0] disp7seg,
	output [31:0] statJ,
	output [31:0] statR,
	output [31:0] statI,
	output [31:0] statTC,
	input clk, reset
);

	// Wire declaration
	wire [31:0] wPC;
	wire [31:0] wPCplus4;

	wire [31:0] wCP0_PCin;
	wire [31:0] wCP0_PCout;
	wire [31:0] wCP0_Dout;
	wire [31:0] wCP0_mux1;

	wire [31:0] wInst;
	wire [31:0] wImm16;
	wire [31:0] wImm5;

	wire [4:0] wRF_mux1;
	wire [4:0] wRF_R1n;
	wire [4:0] wRF_R2n;
	wire [4:0] wRF_RWn;
	wire wRF_WE;
	wire [31:0] wRF_R1data;
	wire [31:0] wRF_R2data;
	wire [31:0] wRF_Din;

	wire [31:0] wALUx;
	wire [31:0] wALUy;
	wire [31:0] wALU_mux1;
	wire [31:0] wALUres;

	wire [31:0] wDMdata;
	wire [31:0] wWriteBack;

	wire IsEret, IsCOP0, HasExp, Equal, BneOrBeq, Branch, Jump, IsJR;
	wire IsJAL, IsShamt, MemtoReg, RegWrite;
	wire ALUSrc, IsSyscall, ZeroExtend;
	wire MemRead, MemWrite, RegDst;
	wire ReadRs, ReadRt, Halt;
	wire ExRegWrite, ExpBlock, ExpSrc0, ExpSrc1, ExpSrc2;
	wire [3:0] ALUop;

	/////////////////////////////////////////////////////////////////

	// IF; Instruction Fetch
	ProgramCounter mPC (
		.progaddr(wPC),
		.prevprog(wPC),
		.op(wInst),
		.jumpamt(wImm16),
		.jumpaddr(wRF_R1data),
		.CP0_PCout(wCP0_PCout),
		.IsEret, .IsCOP0, .HasExp, .Equal, .BneOrBeq,
		.Branch, .Jump, .IsJR, .clk, .reset
	);

	InstMemory #(
		.INIT_FILE1(INIT_FILE1),
		.INIT_FILE2(INIT_FILE2)
	) mIM (
		.dout(wInst),
		.addr(wPC[11:2]),
		.clk, .reset
	);
	/////////////////////////////////////////////////////////////////

	// ID; Instruction Decode
	RegFile mRF (
		.reg1o(wRF_R1data),
		.reg2o(wRF_R2data),
		.reg1n(wRF_R1n),
		.reg2n(wRF_R2n),
		.wregn(wRF_RWn),
		.wdata(wRF_Din),
		.wen(wRF_WE),
		.clk, .reset
	);

	assign wRF_R1n = IsSyscall ? 5'h2 : wInst[25:21];
	assign wRF_R2n = IsSyscall ? 5'h4 : wInst[20:16];
	assign wRF_mux1 = RegDst ? wInst[15:11] : wInst[20:16];
	assign wRF_RWn = IsJAL ? 5'h1f : wRF_mux1;
	assign wRF_WE = IsCOP0 ? ExRegWrite : RegWrite;

	ControlUnit mCU (
		.IsJAL, .IsShamt, .MemtoReg, .RegWrite,
		.BneOrBeq, .ALUSrc, .IsSyscall, .ZeroExtend,
		.MemRead, .MemWrite, .Jump, .Branch, .RegDst,
		.IsJR, .IsCOP0, .ReadRs, .ReadRt,
		.ALUop, .op(wInst[31:26]), .funct(wInst[5:0])
	);

	CP0 mCP (
		.PCout(wCP0_PCout),
		.Dout(wCP0_Dout),
		.ExRegWrite, .ExpBlock, .IsEret, .HasExp,
		.ExpSrc0, .ExpSrc1, .ExpSrc2, .clk, 
		.enable(IsCOP0),
		.Instruction(wInst),
		.PCin(wCP0_PCin),
		.Din(wRF_R2data)
	);

	reg32 PCbuf (
		.readdata(wCP0_PCin),
		.writedata(wPC),
		.wen(1'b1),
		.clk(HasExp), 
		.reset
	);

	assign wPCplus4 = wPC + 32'h4;
	assign wCP0_mux1 = ~IsJAL ? wWriteBack : wPCplus4;
	assign wRF_Din = ~IsCOP0 ? wCP0_mux1 : wCP0_Dout;

	/////////////////////////////////////////////////////////////////

	// EX: Execute
	SyscallDecoder mSD (
		.Halt(Halt),
		.Hex(disp7seg),
		.v0(wRF_R1data),
		.a0(wRF_R2data),
		.en(IsSyscall),
		.clk, .reset
	);

	ALU mALU (
		.result1(wALUres),
		.Equal,
		.sr(wALUx),
		.tg(wALUy),
		.ALUop
	);

	assign wImm5 = {28'b0, wInst[10:6]};
	ImmediateExtender mIE (.out(wImm16), .in(wInst[15:0]), .ZeroExtend);
	assign wALU_mux1 = ALUSrc ? wImm16 : wRF_R2data;
	assign wALUx = IsShamt ? wRF_R2data : wRF_R1data;
	assign wALUy = IsShamt ? wImm5 : wALU_mux1;

	/////////////////////////////////////////////////////////////////

	// MEM: Memory Access
	DataMemory mDM (
		.dout(wDMdata),
		.din(wRF_R2data),
		.addr(wALUres[11:2]),
		.wen(MemWrite),
		.ren(MemRead),
		.clk, .reset
	);

	// WB: Write Back
	assign wWriteBack = MemtoReg ? wDMdata : wALUres;

	/////////////////////////////////////////////////////////////////

	// Statistics
	Statistics mST (
		.J(statJ),
		.R(statR),
		.I(statI),
		.TotalCycles(statTC),
		.op(wInst[31:26]),
		.clk, .rst(reset)
	);

endmodule

module A_CPU_Starter;
	reg clk, reset;
	wire [31:0] disp7seg;
	wire [31:0] statJ;
	wire [31:0] statR;
	wire [31:0] statI;
	wire [31:0] statTC;

	initial begin
		clk = 1'b0;
		reset = 1'b0;
	end

	initial begin
		#5 reset = 1'b1;
		#5 reset = 1'b0;
		#16500 $finish;
	end

	always #5 clk = ~clk;
	always @(posedge CPU.mDM.wen) begin
			#1 $display ("Clock %3d, At 0x%08X, Memory write occured: %3d to 0x%08X", statTC, CPU.wPC, CPU.mDM.din, CPU.mDM.addr);
	end

	SingleCycleCPU # (
		.INIT_FILE1("prog1.hex"),
		.INIT_FILE2("prog2.hex")
	) CPU (
		.disp7seg, .statJ, .statR, .statI, .statTC, .clk, .reset
	);

endmodule