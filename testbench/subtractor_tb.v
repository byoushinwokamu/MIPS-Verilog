module Sub_tb;
	reg [31:0] sr, tg;
	reg bin;
	wire [31:0] res;
	wire CF, OF;

	Sub inst (
		.res(res),
		.CF(CF),
		.OF(OF),
		.sr(sr),
		.tg(tg),
		.bin(bin)
	);

	task test;
		input [31:0] a, b;
		input c;
		begin
			sr = a;
			tg = b;
			bin = c;
			#1;
			$display("sr = 0x%08X, tg = 0x%08X, bin = %b", sr, tg, bin);
			$display(" → res = 0x%08X, CF(borrow) = %b, OF = %b", res, CF, OF);
			$display("--------------------------------------------");
		end
	endtask

	initial begin
		$display("=== Sub Module Test ===");

		// 기본 뺄셈
		test(32'h00000005, 32'h00000002, 0);  // 5 - 2 = 3
		test(32'h00000005, 32'h00000005, 0);  // 5 - 5 = 0

		// borrow 발생 (a < b)
		test(32'h00000001, 32'h00000002, 0);  // CF = 1

		// signed overflow: 양수 - 음수 = 음수 (잘못된 부호)
		test(32'h7FFFFFFF, 32'hFFFFFFFF, 0);  // OF = 1

		// signed overflow: 음수 - 양수 = 양수 (잘못된 부호)
		test(32'h80000000, 32'h00000001, 0);  // OF = 1

		// bin 포함 (1 빼기 더)
		test(32'h00000002, 32'h00000001, 1);  // 2 - 1 - 1 = 0

		$display("=== Test Done ===");
		#10 $finish;
	end

endmodule
