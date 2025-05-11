module Mul (res, cout, sr, tg, cin);
	output [31:0] res;
	output [31:0] cout;
	input [31:0] sr;
	input [31:0] tg;
	input cin;

	assign {cout, res} = sr * tg + cin;

endmodule

module Div (res, rem, sr, tg, upper);
	output [31:0] res;
	output [31:0] rem;
	input [31:0] sr;
	input [31:0] tg;
	input upper;

	assign res = (sr + upper) / tg;
	assign rem = (sr + upper) % tg;

endmodule