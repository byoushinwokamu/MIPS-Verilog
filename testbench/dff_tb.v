module dff_tb;
	reg d, clk, en, rst;
	wire q;
	dff inst(q, d, clk, en, rst);

	always #5 clk = ~clk;

	initial begin
		d = 0; clk = 0; en = 0; rst = 0;
		#5 rst = 1; #5 rst = 0;

		#10 d = 1;
		#10 en  = 1;

		#10 d = 0;

		#10 en = 0; d = 1;

		#10 en = 1;

		#5 rst = 1; #5 rst = 0;

		#30 $finish;
	end

endmodule
