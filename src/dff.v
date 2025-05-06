module dff (q, d, clk, enable, reset);
	output reg q;
	input d, clk, enable, reset;

	always @(posedge clk or posedge reset) begin
		if (reset) q <= 0;
		else if (enable) q <= d;
	end

endmodule
