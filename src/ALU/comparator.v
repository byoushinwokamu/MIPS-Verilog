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
