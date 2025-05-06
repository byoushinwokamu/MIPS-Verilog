module DataMemory (dout, din, addr, clk, wen, ren, reset);
	output reg [31:0] dout;
	input [31:0] din;
	input [9:0] addr;
	input clk, wen, ren, reset;
	
	// 1024 × 8bit RAM
	reg [7:0] mem [1023:0];
	integer i;

	always @(posedge clk or posedge reset) begin
		if (reset)
			for (i = 0; i < 1024; i = i+1) mem[i] <= 8'b0;
		if (wen)
			{mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]} <= din;
		if (ren)
			dout <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
	end

endmodule
