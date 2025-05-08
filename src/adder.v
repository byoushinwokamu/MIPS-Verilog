module adder1 (sum, cout, a, b, cin);
	output sum, cout;
	input a, b, cin;

	wire xor1, and1, and2;
	xor (xor1, a, b);
	xor (sum, xor1, cin);
	and (and1, xor1, cin);
	and (and2, a, b);
	or (cout, and1, and2);

endmodule

module adder31 (sum, cout, a, b, cin);
	output [30:0] sum;
	output cout;
	input [30:0] a;
	input [30:0] b;
	input cin;

	wire [29:0] c;
	adder1 adders [30:0] (
		.sum, .cout({cout, c}),
		.a, .b, .cin({c, cin})
	);

endmodule

module Add (res, CF, OF, sr, tg, cin);
	output [31:0] res;
	output CF, OF;
	input [31:0] sr;
	input [31:0] tg;
	input cin;

	wire cc;
	adder31 adder_upper (
		.sum(res[30:0]), .cout(cc),
		.a(sr[30:0]), .b(tg[30:0]), .cin(cin)
	);
	adder1 adder_lower (
		.sum(res[31]), .cout(CF),
		.a(sr[31]), .b(tg[31]), .cin(cc)
	);
	xor (OF, cc, CF);

endmodule
