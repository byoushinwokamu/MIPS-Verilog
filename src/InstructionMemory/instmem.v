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

module InstMemory_tb;
	reg clk = 0;
	reg reset = 0;
	reg [9:0] addr = 0;
	wire [31:0] dout;

	// DUT
	InstMemory #(
		.INIT_FILE1("program1.hex"),
		.INIT_FILE2("program2.hex")
	) dut (
		.dout(dout),
		.addr(addr),
		.clk(clk),
		.reset(reset)
	);

	// Clock generation
	always #5 clk = ~clk;

	initial begin
		$display("=== InstMemory Dual-ROM Test Start ===");

		// Reset and wait for $readmemh
		#5 reset = 1;
		#10 reset = 0;

		// Read from lower ROM (addr[9] = 0)
		addr = 10'd0;  #10 $display("addr %3d (ROM1) -> dout = 0x%08X", addr, dout);
		addr = 10'd1;  #10 $display("addr %3d (ROM1) -> dout = 0x%08X", addr, dout);
		addr = 10'd2;  #10 $display("addr %3d (ROM1) -> dout = 0x%08X", addr, dout);

		// Read from upper ROM (addr[9] = 1)
		addr = 10'd512;  #10 $display("addr %3d (ROM2) -> dout = 0x%08X", addr, dout);
		addr = 10'd513;  #10 $display("addr %3d (ROM2) -> dout = 0x%08X", addr, dout);
		addr = 10'd514;  #10 $display("addr %3d (ROM2) -> dout = 0x%08X", addr, dout);

		$display("=== Test Done ===");
		#10 $finish;
	end

endmodule