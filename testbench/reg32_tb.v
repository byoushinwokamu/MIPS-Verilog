module reg32_tb;
	wire [31:0] q;
	reg [31:0] d;
	reg clk, wen, rst;
	reg32 inst(q, d, clk, wen, rst);

	always #5 clk = ~clk;

	initial begin
		d <= 32'd0; clk <= 0; wen <= 0;
		rst <= 1; 

		#10 rst <= 0;
		d <= 32'h1234abcd; wen <= 1;

		#10
		d <= 32'hdfdf7878;

		#10
		d <= 32'hffffffff; wen <= 0;

		#10
		wen <= 1;

		#10 $finish;
	end
	
endmodule