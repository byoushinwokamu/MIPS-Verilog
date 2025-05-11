module ShiftLeftLogic (res, tg, sh);
	output reg [31:0] res; // result
	input [31:0] tg;       // target
	input [4:0] sh;        // shamt

	integer i;
	always @(*) begin
		for (i = 0; i < 32; i = i+1)
			res[i] = (i < sh) ? 1'b0 : tg[i - sh];
	end

endmodule
