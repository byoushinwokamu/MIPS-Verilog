module InstMem_half #(
    parameter INIT_FILE = "program.hex" 
) (dout, addr, clk, reset);
	output reg [31:0] dout;
	input [8:0] addr;
	input clk, reset;

	// 512byte ROM
	reg [31:0] rom [0:511];
	integer i;

	// always @(posedge clk or posedge reset) begin
	always @(*) begin
		if (reset) begin
			for (i = 0; i < 512; i = i+1) rom[i] = 8'b0;
			$readmemh(INIT_FILE, rom);
		end else dout <= rom[addr];
	end

endmodule

module InstMem_half_tb;
	reg clk, reset;
	reg [8:0] addr;
	wire [31:0] dout;

	// DUT instantiation
	InstMem_half #(.INIT_FILE("program.hex")) inst (
		.dout(dout),
		.addr(addr),
		.clk(clk),
		.reset(reset)
	);

	// Clock generation
	always #5 clk = ~clk;

	initial begin
		// Initial setting
		clk = 0; reset = 0;
		addr = 0; 
		$display("=== InstMemory Test Start ===");

		// Reset
		#5 reset = 1;
		#10 reset = 0;

		// Read from addr 0
		#10 addr = 9'd0;
		#10 $display("Read from addr 0 = 0x%08X (expected 0x20080005)", dout);

		// Read from addr 1
		#10 addr = 9'd1;
		#10 $display("Read from addr 1 = 0x%08X (expected 0x20090003)", dout);

		// Read from addr 2
		#10 addr = 9'd2;
		#10 $display("Read from addr 2 = 0x%08X (expected 0x01095020)", dout);

		// Read from addr 3
		#10 addr = 9'd3;
		#10 $display("Read from addr 3 = 0x%08X (expected 0x00000000)", dout);

		$display("=== InstMemory Test Done ===");
		#10 $finish;
	end

endmodule