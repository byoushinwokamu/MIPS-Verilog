module CP0 (
	output [31:0] PCout,
	output [31:0] Dout,
	output ExRegWrite, ExpBlock, IsEret, HasExp,
	input ExpSrc0, ExpSrc1, ExpSrc2, clk, enable,
	input [31:0] Instruction,
	input [31:0] PCin,
	input [31:0] Din,
	input reset
);
	wire [1:0] sel;
	wire BlockSrc0, BlockSrc1, BlockSrc2;
	wire wes1, wes2, wes3, ExpClick;
	wire [31:0] wrm0;
	wire [31:0] wrm1;
	wire [31:0] wrm2;
	wire [31:0] wrm3;
	wire wand0, wand1, wand2, wand3, wdm0, wdm1, wdm2, wor1;

	// Signal Decoding
	assign ExRegWrite = ~Instruction[23];
	assign sel = Instruction[12:11];
	and (
		IsEret, ~Instruction[5], Instruction[4], Instruction[3], 
	  ~Instruction[2], ~Instruction[1], ~Instruction[0]
	);

	// Exception Signals
	or (
		wes1, 
		BlockSrc0 ? 1'b0: ExpSrc0,
		BlockSrc1 ? 1'b0: ExpSrc1,
		BlockSrc2 ? 1'b0: ExpSrc2
	);
	and (ExpClick, wes1, ~ExpBlock);
	dff dff1 (
		.q(wes2), .d(~wes2), .clk(ExpClick), .enable(1'b1), .reset(wes3)
	);
	dff dff2 (
		.q(wes3), .d(~wes3), .clk(HasExp), .enable(1'b1), .reset(~wes2)
	);
	and (HasExp, clk, wes2);

	// Registers
	wire [31:0] causein;
	assign causein = ExpSrc0 ? 32'h1 : (ExpSrc1 ? 32'h3 : (ExpSrc2 ? 32'h7 : 32'hzzzzzzzz));
	reg32 Cause (.readdata(wrm3), .writedata(causein), .clk(ExpClick), .wen(1'b1), .reset);

	reg32 Block (.readdata(wrm2), .writedata(Din), .clk, .wen(wand3), .reset);

	reg32 Status (.readdata(wrm1), .writedata(Din), .clk, .wen(wand2), .reset);
	assign ExpBlock = wrm1[0];

	and (wand0, enable, ~ExRegWrite);
	assign wdm0 = (sel == 2'b00) ? 1'b1 : 1'b0;
	assign wdm1 = (sel == 2'b01) ? 1'b1 : 1'b0;
	assign wdm2 = (sel == 2'b10) ? 1'b1 : 1'b0;
	and (wand1, wand0, wdm0);
	and (wand2, wand0, wdm1);
	and (wand3, wand0, wdm2);

	or(wor1, HasExp, wand1);
	wire [31:0] epcin;
	assign epcin = (HasExp == 1'b1) ? PCin : Din;
	reg32 EPC (.readdata(wrm0), .writedata(epcin), .clk, .wen(wor1), .reset);

	assign PCout = wrm0;
	assign Dout = (sel[1] == 1'b0) ? ((sel[0] == 1'b0) ? wrm0 : wrm1)
																 : ((sel[0] == 1'b0) ? wrm2 : wrm3);

endmodule