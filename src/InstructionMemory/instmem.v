module InstMemory #(
	parameter INIT_FILE1 = "program1.hex", INIT_FILE2 = "program2.hex"
) (dout, addr, clk, reset);
	output [31:0] dout;
	input [9:0] addr;
	input clk, reset;

	wire memsel;
	wire [31:0] dout1;
	wire [31:0] dout2;
	InstMem_half #(.INIT_FILE(INIT_FILE1)) IMem1 (
		.dout(dout1), .addr(addr[8:0]), .clk(clk), .reset(reset)
	);
	InstMem_half #(.INIT_FILE(INIT_FILE2)) IMem2 (
		.dout(dout2), .addr(addr[8:0]), .clk(clk), .reset(reset)
	);

	// Multiplexing output
	assign dout = (addr[9] ? dout2 : dout1);

endmodule
