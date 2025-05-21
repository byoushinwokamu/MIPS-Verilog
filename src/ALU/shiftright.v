module ShiftRightArith (res, tg, sh);
	output reg [31:0] res; // result
	input [31:0] tg;       // target
	input [4:0] sh;        // shamt

	integer i;
	always @(*) begin
		for (i = 0; i < 32; i = i+1)
			res[i] = (i >= (32 - sh)) ? tg[31] : tg[i + sh];
	end

endmodule

module ShiftRightLogic (res, tg, sh);
	output reg [31:0] res; // result
	input [31:0] tg;       // target
	input [4:0] sh;        // shamt

	integer i;
	always @(*) begin
		for (i = 0; i < 32; i = i+1)
			res[i] = (i >= (32 - sh)) ? 1'b0 : tg[i + sh];
	end

endmodule

module ShiftRight_tb;
	reg [31:0] tg;
	reg [4:0] sh;
	wire [31:0] res_arith, res_logic;

	ShiftRightArith sra (
		.res(res_arith),
		.tg(tg),
		.sh(sh)
	);

	ShiftRightLogic srl (
		.res(res_logic),
		.tg(tg),
		.sh(sh)
	);

	task test;
		input [31:0] tg_in;
		input [4:0] shamt;
		begin
			tg = tg_in;
			sh = shamt;
			#1; // combinational delay
			$display("tg = 0x%08X, sh = %2d", tg, sh);
			$display("  srl → 0x%08X (expected %08X)", res_logic, tg >> sh);
			$display("  sra → 0x%08X (expected %08X)", res_arith, $signed(tg) >>> sh);
			$display("--------------------------------------------");
		end
	endtask

	initial begin
		$display("=== ShiftRightArith & Logic Test ===");

		// 양수
		test(32'h0000_00F0, 4);   // 논리/산술 같음
		test(32'h7FFF_FFFF, 1);   // 논리/산술 같음

		// 음수
		test(32'hFFFF_FFF0, 4);   // 상위 비트 부호 확장 확인
		test(32'h8000_0000, 2);   // sra는 상위 1 유지
		test(32'hFFFF_FFFF, 8);   // sra는 여전히 음수

		// zero shift
		test(32'h1234_5678, 0);   // 그대로 나와야 함

		$display("=== Test Done ===");
		#10 $finish;
	end

endmodule