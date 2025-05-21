module subtractor1 (diff, bout, a, b, bin);
	output diff, bout;
	input a, b, bin;

	wire xor1, and1, and2;
	xor (xor1, a, b);
	xor (diff, xor1, bin);
	and (and1, bin, ~xor1);
	and (and2, ~a, b);
	or (bout, and1, and2);

endmodule

module subtractor31 (diff, bout, a, b, bin);
	output [30:0] diff;
	output bout;
	input [30:0] a;
	input [30:0] b;
	input bin;

	wire [29:0] bb;
	subtractor1 subs [30:0] (
		.diff, .bout({bout, bb}),
		.a, .b, .bin({bb, bin})
	);

endmodule

module Sub (res, CF, OF, sr, tg, bin);
	output [31:0] res;
	output CF, OF;
	input [31:0] sr;
	input [31:0] tg;
	input bin;

	wire bb;
	subtractor31 sub_upper (
		.diff(res[30:0]), .bout(bb),
		.a(sr[30:0]), .b(tg[30:0]), .bin(bin)
	);
	subtractor1 sub_lower (
		.diff(res[31]), .bout(CF),
		.a(sr[31]), .b(tg[31]), .bin(bb)
	);
	xor (OF, bb, CF);

endmodule

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