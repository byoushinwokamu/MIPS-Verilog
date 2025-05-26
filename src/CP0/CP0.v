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
	wire wesdmx1, wesdmx2, wesdmx3;
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
	assign wesdmx1 = BlockSrc0 ? 1'b0 : ExpSrc0;
	assign wesdmx2 = BlockSrc1 ? 1'b0 : ExpSrc1;
	assign wesdmx3 = BlockSrc2 ? 1'b0 : ExpSrc2;
	or (wes1,	wesdmx1, wesdmx2, wesdmx3);
	and (ExpClick, wes1, ~ExpBlock);
	counter1 cnt1 (
		.q(wes2), .clk(ExpClick), .clear(wes3), .rst(reset)
	);
	counter1 cnt2 (
		.q(wes3), .clk(HasExp), .clear(~wes2), .rst(reset)
	);
	and (HasExp, clk, wes2);

	// Registers
	wire [31:0] causein;
	assign causein = {29'b0, ExpSrc2, ExpSrc1 | ExpSrc2, ExpSrc0 | ExpSrc1 | ExpSrc2};
	reg32 Cause (.readdata(wrm3), .writedata(causein), .clk(ExpClick), .wen(1'b1), .reset);

	reg32 Block (.readdata(wrm2), .writedata(Din), .clk, .wen(wand3), .reset);
	assign BlockSrc0 = wrm2[0];
	assign BlockSrc1 = wrm2[1];
	assign BlockSrc2 = wrm2[2];

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

module tb_CP0;

  reg clk, reset, enable;
  reg ExpSrc0, ExpSrc1, ExpSrc2;
  reg [31:0] Instruction, PCin, Din;
  wire [31:0] PCout, Dout;
  wire ExRegWrite, ExpBlock, IsEret, HasExp;

  CP0 dut (
    .PCout, .Dout, .ExRegWrite, .ExpBlock, .IsEret, .HasExp,
    .ExpSrc0, .ExpSrc1, .ExpSrc2, .clk, .enable,
    .Instruction, .PCin, .Din, .reset
  );

  task tick;
    begin
      #1 clk = 1;
      #1 clk = 0;
    end
  endtask

  task test_exception_input;
    input [31:0] instr;
    input src0, src1, src2;
    input [31:0] pcval;
    input [31:0] dinval;
    input [8*20:1] label;
    begin
      Instruction = instr;
      ExpSrc0 = src0;
      ExpSrc1 = src1;
      ExpSrc2 = src2;
      PCin = pcval;
      Din = dinval;
      enable = 1;

      tick();

      $display("[%s] ExpSrc = %b%b%b", label, src2, src1, src0);
      $display("    HasExp = %b", HasExp);
      $display("    PCout  = %h", PCout);
      $display("    Dout   = %h", Dout);
    end
  endtask

  initial begin
    clk = 0;
    reset = 1;
    Instruction = 32'd0;
    ExpSrc0 = 0;
    ExpSrc1 = 0;
    ExpSrc2 = 0;
    enable = 0;
    PCin = 32'h1000_0000;
    Din = 32'hDEAD_BEEF;
    tick();
    reset = 0;

    // Basic eret detection
    Instruction = 32'b010000_00000_00000_00000_00000_011000;
    #1;
    $display("[IsEret] IsEret = %b (expected 1) %s", IsEret, (IsEret == 1'b1) ? "OK" : "MISMATCH");

    // Write EPC via exception trigger (src2 only)
    test_exception_input(32'd0, 0, 0, 1, 32'h1234_5678, 32'hCAFEBABE, "ExpSrc2 only");

    // Trigger all three exception sources
    test_exception_input(32'd0, 1, 1, 1, 32'h8765_4321, 32'hBEEFCAFE, "All ExpSrc");

    // Explicit write with enable
    Instruction = 32'b010000_00000_00000_00000_00000_000000; // sel = 00, ExRegWrite = 1
    enable = 1;
    Din = 32'hFEEDFACE;
    tick();

    $display("All CP0 tests completed.");
    $finish;
  end
endmodule
