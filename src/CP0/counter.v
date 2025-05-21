module counter1 (output reg q, input clk, clear, rst);
	always @(posedge clk or posedge clear or posedge rst) begin
		if (clear || rst) q <= 1'b0;
		else q <= ~q;
	end

endmodule