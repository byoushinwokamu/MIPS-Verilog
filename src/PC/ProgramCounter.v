module ProgramCounter (
	output [31:0] progaddr,
	input [31:0] prevprog,
	input [31:0] op,
	input [31:0] jumpamt,
	input [31:0] jumpaddr,
	input [31:0] CP0_PCout,
	input IsEret, IsCOP0, HasExp, Equal, BneOrBeq, Branch, Jump, IsJR, clk, reset
);
	wire [31:0] wnextprog;
	wire [31:0] wjump;
	wire [31:0] wjadd;
	wire [31:0] wmux1;
	wire [31:0] wmux2;
	wire wand1;
	wire [31:0] wfinalpc;
	wire [31:0] wmux3;
	wire [31:0] wmux4;
	wire wmux5, wand2, wor1;

	assign wnextprog = prevprog + 32'h4;
	assign wjump = {wnextprog[31:28], op[25:0], 2'b0};
	assign wjadd = wnextprog + (jumpamt << 2);
	and (wand1, Branch, Equal ^ BneOrBeq);
	assign wmux1 = wand1 ? wjadd : wnextprog;
	assign wmux2 = ~Jump ? wmux1 : wjump;
	assign wfinalpc = IsJR ? jumpaddr : wmux2;

	and (wand2, IsEret, IsCOP0);
	or (wor1, wand2, HasExp);
	assign wmux3 = wand2 ? CP0_PCout : wfinalpc;
	assign wmux4 = ~HasExp ? wmux3 : 32'h800;
	assign wmux5 = wor1 ? ~clk : clk;

	reg32 PC (.readdata(progaddr), .writedata(wmux4), .clk(wmux5), .wen(1'b1), .reset);

endmodule

module tb_ProgramCounter;

  reg [31:0] prevprog, op, jumpamt, jumpaddr, CP0_PCout;
  reg IsEret, IsCOP0, HasExp, Equal, BneOrBeq, Branch, Jump, IsJR, clk, reset;
  wire [31:0] progaddr;

  ProgramCounter dut (
    .progaddr(progaddr), .prevprog(prevprog), .op(op), .jumpamt(jumpamt),
    .jumpaddr(jumpaddr), .CP0_PCout(CP0_PCout), .IsEret(IsEret), .IsCOP0(IsCOP0),
    .HasExp(HasExp), .Equal(Equal), .BneOrBeq(BneOrBeq), .Branch(Branch),
    .Jump(Jump), .IsJR(IsJR), .clk(clk), .reset(reset)
  );

  task tick;
    begin
      #1 clk = 1; #1 clk = 0;
    end
  endtask

  task test_pc;
    input [31:0] init_pc;
    input [31:0] opval;
    input [31:0] jaddr;
    input [31:0] jamt;
    input [31:0] cp0val;
    input br;
    input j;
    input jr;
    input eq;
    input bne;
    input iseret;
    input iscop0;
    input hasexp;
    input [31:0] expected;
    input [8*32:1] label;
    begin
      prevprog = init_pc;
      op = opval;
      jumpamt = jamt;
      jumpaddr = jaddr;
      CP0_PCout = cp0val;
      Branch = br;
      Jump = j;
      IsJR = jr;
      Equal = eq;
      BneOrBeq = bne;
      IsEret = iseret;
      IsCOP0 = iscop0;
      HasExp = hasexp;
      tick();

      $display("[%s]", label);
      $display("    progaddr = %h (expected %h) %s", progaddr, expected, (progaddr == expected) ? "OK" : "MISMATCH");
    end
  endtask

  initial begin
    clk = 0;
    reset = 1;
    tick();
    reset = 0;

    // Normal PC increment
    test_pc(32'h0040_0000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32'h0040_0004, "Next PC no branch");

    // Branch taken (beq, equal)
    test_pc(32'h0040_0000, 0, 0, 4, 0, 1, 0, 0, 1, 0, 0, 0, 0, 32'h0040_0014, "Branch taken");

    // Branch not taken (bne, equal)
    test_pc(32'h0040_0000, 0, 0, 4, 0, 1, 0, 0, 1, 1, 0, 0, 0, 32'h0040_0004, "Branch not taken");

    // Jump
    test_pc(32'h0040_0000, 32'h0000_1234, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 32'h0000_48D0, "Jump address");

    // Jump Register
    test_pc(32'h0040_0000, 0, 32'h9000_0000, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 32'h9000_0000, "Jump register");

    $display("ProgramCounter tests completed.");
    $finish;
  end
endmodule
