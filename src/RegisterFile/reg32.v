module reg32 (readdata, writedata, clk, wen, reset);
	output [31:0] readdata;
	input [31:0] writedata;
	input clk, wen, reset;

	dff dffs [31:0] (readdata, writedata, clk, wen, reset);

endmodule

module reg32_ll (readdata, writedata, clk, wen, reset);
	output reg [31:0] readdata;
	input [31:0] writedata;
	input clk, wen, reset;

	always @(*) begin
		if (reset) readdata <= 32'b0;
		else if (~clk && wen) readdata <= writedata;
	end

endmodule