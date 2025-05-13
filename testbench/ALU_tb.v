module ALU_tb;
	reg [31:0] sr, tg;
	reg [3:0] ALUop;
	wire [31:0] result1, result2;
	wire OF, CF, Equal;

	ALU inst (
		.result1(result1), .result2(result2),
		.OF(OF), .CF(CF), .Equal(Equal),
		.sr(sr), .tg(tg), .ALUop(ALUop)
	);

	task test;
		input [3:0] op;
		input [31:0] a, b;
		begin
			ALUop = op;
			sr = a;
			tg = b;
			#1;
			$display("[ALUop %2d] sr = 0x%08X, tg = 0x%08X", ALUop, sr, tg);
			$display("  → result1 = 0x%08X, result2 = 0x%08X, OF = %b, CF = %b, Equal = %b",
					result1, result2, OF, CF, Equal);
			$display("--------------------------------------------------------");
		end
	endtask

	initial begin
		$display("=== ALU Test ===");

		test(0, 32'h00000001, 32'd4);   // sll
		test(1, 32'hF0000000, 32'd4);   // sra
		test(2, 32'hF0000000, 32'd4);   // srl

		test(3, 32'h00000010, 32'h00000004); // mul: 16 × 4 = 64

		test(4, 32'h00000010, 32'h00000003); // div: 16 / 3 = 5, rem = 1

		test(5, 32'h7FFFFFFF, 32'd1);   // add: overflow 발생
		test(6, 32'h80000000, 32'd1);   // sub: overflow 발생

		test(7, 32'hFF00FF00, 32'h0F0F0F0F); // and
		test(8, 32'hF0000000, 32'h0000FFFF); // or
		test(9, 32'hAAAA5555, 32'hFFFF0000); // xor
		test(10, 32'h00000000, 32'h00000000); // nor

		test(11, -5, 3);                // signed comp: 1
		test(11, 5, -3);                // signed comp: 0

		test(12, 32'h00000001, 32'hFFFFFFFF); // unsigned comp: 1
		test(12, 32'hFFFFFFFF, 32'h00000001); // unsigned comp: 0

		$display("=== Test Done ===");
		#10 $finish;
	end

endmodule
