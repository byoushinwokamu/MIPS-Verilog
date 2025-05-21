module LessThan (lt, sr, tg);
	output reg lt; // res be 1 if sr < tg
	input [31:0] sr;
	input [31:0] tg;

	wire CF;
	Sub subtract (
		.CF, .sr, .tg, .bin(1'b0)
	);

	always @(*) begin
		if (sr[31] && ~tg[31]) lt <= 1'b1;
		else if (~sr[31] && tg[31]) lt <= 1'b0;
		else lt <= CF;
	end

endmodule

module LessThanUnsigned (lt, eq, sr, tg);
	output lt, eq;
	input [31:0] sr;
	input [31:0] tg;

	wire CF;
	Sub subtract (
		.CF, .sr, .tg, .bin(1'b0)
	);

	assign lt = CF;
	assign eq = (sr == tg);

endmodule

module Comparator_tb;
	reg [31:0] a, b;
	wire res, resu, reseq;

	LessThan complt (
		.lt(res),
		.sr(a),
		.tg(b)
	);

	LessThanUnsigned comptltu (
		.lt(resu),
		.eq(reseq),
		.sr(a),
		.tg(b)
	);

	task test;
		input [31:0] x, y;
		begin
			a = x; b = y;
			#1;
			$display("a = 0x%08X, b = 0x%08X", a, b);
			$display(" lt = %b, ltu = %b, eq = %b", res, resu, reseq);
			$display("----------------------------------------");
		end
	endtask

	initial begin
		$display("=== Comparator Test ===");

		test(32'd5, 32'd5);         // 5 = 5 (0 0 1)
		test(32'd3, 32'd7);         // 3 < 7 (1 1 0)
		test(32'd8, 32'd4);         // 8 > 4 (0 0 0)
		test(-32'sd2, 32'sd3);      // -2 < 3 (1 0 0)
		test(32'sd2, -32'sd3);      // -3 is very large when unsigned (0 1 0)
		test(32'hFFFFFFFF, 32'd0);  // -1 < 0 (1 0 0)

		$display("=== Done ===");
		#10 $finish;
	end

endmodule
