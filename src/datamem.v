module DataMemory (dout, din, addr, clk, wen, ren, reset);
	output reg [31:0] dout;
	input [31:0] din;
	input [9:0] addr;
	input clk, wen, ren, reset;
	
	// 1024 × 4byte RAM
	reg [31:0] mem [1023:0];
	integer i;

	always @(posedge clk or posedge reset) begin
		if (reset)
			for (i = 0; i < 1024; i = i+1) mem[i] <= 32'b0;
		else begin
			if (wen) mem[addr] <= din;
			if (ren) dout <= mem[addr]; 
		end
	end

endmodule
