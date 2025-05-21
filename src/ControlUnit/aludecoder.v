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

module ALUDecoder_tb;
  reg [5:0] op, ft;
  wire IsSyscall, IsJR, IsShamt;
  wire [3:0] ALUop;

  ALUDecoder inst (
    .IsSyscall(IsSyscall),
    .IsJR(IsJR),
    .IsShamt(IsShamt),
    .ALUop(ALUop),
    .op0(op[5]), .op1(op[4]), .op2(op[3]),
    .op3(op[2]), .op4(op[1]), .op5(op[0]),
    .ft0(ft[5]), .ft1(ft[4]), .ft2(ft[3]),
    .ft3(ft[2]), .ft4(ft[1]), .ft5(ft[0])
  );

  task test_case;
    input [5:0] op_in, ft_in;
    input [3:0] exp_op;
    input exp_syscall, exp_jr, exp_shamt;
    begin
      op = op_in; ft = ft_in;
      #1; // wait for combinational logic

      $display("OP: %b, FT: %b", op, ft);
      $display("  IsSyscall = %b (exp %b)", IsSyscall, exp_syscall);
      $display("  IsJR      = %b (exp %b)", IsJR, exp_jr);
      $display("  IsShamt   = %b (exp %b)", IsShamt, exp_shamt);
      $display("  ALUop     = %b (exp %b)", ALUop, exp_op);
      $display("-----------------------------");
    end
  endtask

  initial begin
    $display("=== ALUDecoder All-Type Test Start ===");

		// R-type
		test_case(6'b000000, 6'b100000, 4'b0101, 0, 0, 0); // add
		test_case(6'b000000, 6'b100010, 4'b0110, 0, 0, 0); // sub
		test_case(6'b000000, 6'b100100, 4'b0111, 0, 0, 0); // and 
		test_case(6'b000000, 6'b100101, 4'b1000, 0, 0, 0); // or
		test_case(6'b000000, 6'b100111, 4'b1010, 0, 0, 0); // nor
		test_case(6'b000000, 6'b101010, 4'b1011, 0, 0, 0); // slt
		test_case(6'b000000, 6'b101011, 4'b1100, 0, 0, 0); // sltu
		test_case(6'b000000, 6'b000000, 4'b0000, 0, 0, 1); // sll
		test_case(6'b000000, 6'b000010, 4'b0010, 0, 0, 1); // srl
		test_case(6'b000000, 6'b000011, 4'b0001, 0, 0, 1); // sra
		test_case(6'b000000, 6'b001000, 4'b0000, 0, 1, 0); // jr
		test_case(6'b000000, 6'b001100, 4'b0000, 1, 0, 0); // syscall

		// I-type
		test_case(6'b001000, 6'bxxxxxx, 4'b0101, 0, 0, 0); // addi
		test_case(6'b001001, 6'bxxxxxx, 4'b0101, 0, 0, 0); // addiu
		test_case(6'b001100, 6'bxxxxxx, 4'b0111, 0, 0, 0); // andi
		test_case(6'b001101, 6'bxxxxxx, 4'b1000, 0, 0, 0); // ori
		test_case(6'b001010, 6'bxxxxxx, 4'b1011, 0, 0, 0); // slti
		// test_case(6'b001011, 6'bxxxxxx, 4'b1100, 0, 0, 0); // sltiu 

    $display("=== ALUDecoder Test Done ===");
    #10 $finish;
  end

endmodule