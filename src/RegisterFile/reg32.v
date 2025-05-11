module reg32 (readdata, writedata, clk, wen, reset);
	output [31:0] readdata;
	input [31:0] writedata;
	input clk, wen, reset;

	dff dffs [31:0] (readdata, writedata, clk, wen, reset);

endmodule
