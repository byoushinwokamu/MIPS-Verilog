module InstMem_half #(
    parameter INIT_FILE = "program.hex" 
) (dout, addr, clk, reset);
	output reg [31:0] dout;
	input [8:0] addr;
	input clk, reset;

	// 512 × 4byte ROM
	reg [31:0] rom [0:511];
	integer i;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			for (i = 0; i < 512; i = i+1) rom[i] = 32'b0;
			$readmemh(INIT_FILE, rom);
		end else dout <= rom[addr];
	end

endmodule
