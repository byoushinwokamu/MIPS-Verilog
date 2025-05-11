module Compare (res, sr, tg);
	output reg res; // res be 1 if sr < tg
	input [31:0] sr;
	input [31:0] tg;

	integer i;
	always @(*) begin
		if (~sr[31] ^ tg[31]) begin
			for (i = 30; i >= 0; i = i-1)
		end
		else if (sr[31]) res = 1'b0;
		else res = 1'b1;
	end

endmodule