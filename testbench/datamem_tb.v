module DataMemory_tb;
	reg clk, wen, ren, reset;
	reg [9:0] addr;
	reg [31:0] din;
	wire [31:0] dout;

	DataMemory inst (
		.dout(dout),
		.din(din),
		.addr(addr),
		.clk(clk),
		.wen(wen),
		.ren(ren),
		.reset(reset)
	);

	// Clock generation
	always #5 clk = ~clk;

	initial begin
		// Init
		clk = 0; wen = 0; ren = 0; reset = 0;
		addr = 0; din = 0;
		$display("=== RAM Test Start ===");

		// Reset memory
		#5 reset = 1;
		#10 reset = 0;

		// Write value
		#10 wen = 1; ren = 0;
			addr = 10'd12;   // Must be word-aligned (e.g. 12 = 0x0C)
			din  = 32'hDEADBEEF;
		#10 wen = 0;

		// Read value
		#10 ren = 1;
		#10 ren = 0;
		#1  $display("Read from addr %0d = 0x%08X (expected 0xDEADBEEF)", addr, dout);

		// Write another value
		#10 wen = 1; addr = 10'd100; din = 32'h12345678;
		#10 wen = 0;

		// Read it back
		#10 ren = 1; addr = 10'd100;
		#10 ren = 0;
		#1  $display("Read from addr %0d = 0x%08X (expected 0x12345678)", addr, dout);

		$display("=== RAM Test Done ===");
		#10 $finish;
	end
endmodule
