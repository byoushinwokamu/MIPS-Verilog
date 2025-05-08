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
