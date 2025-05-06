module RegFile_tb;
	wire [31:0] reg1o;
	wire [31:0] reg2o;
	reg [4:0] reg1n;
	reg [4:0] reg2n;
	reg [4:0] wregn;
	reg [31:0] wdata;
	reg wen, clk, reset;
	RegFile inst(reg1o, reg2o, reg1n, reg2n, wregn, wdata, wen, clk, reset);
	integer i;

	// Reference memory
	reg [31:0] golden_reg [0:31];

	always #5 clk = ~clk;

	initial begin
		reg1n <= 0; reg2n <= 0; wregn <= 0; wdata <= 0;
		wen <= 0; clk <= 0; reset <= 0;

		$display("===== RegFile Test Start =====");

		// Reset
		#5 reset <= 1;
		#5 reset <= 0;
		for (i = 0; i < 32; i = i+1) golden_reg[i] = 0; 

		// Write phase
		wen <= 1;
		for (i = 1; i < 32; i = i+1) begin
			wregn <= i;
			wdata <= i;
			golden_reg[i] = i;
			#10;
			$display("Write: reg[%0d] <= %0d", i, i);
		end

		// Disable write
		wen <= 0;

		// Read and check phase
		for (i = 0; i < 32; i = i+1) begin
			reg1n <= i;
			reg2n <= i;
			#10;
			if (reg1o !== golden_reg[i])
				$display("*** reg1o MISMATCH at reg[%0d]: got %0d, expected %0d", i, reg1o, golden_reg[i]);
			else
				$display(":) reg1o match at reg[%0d]: %0d", i, reg1o);

			if (reg2o !== golden_reg[i])
				$display("*** reg2o MISMATCH at reg[%0d]: got %0d, expected %0d", i, reg2o, golden_reg[i]);
			else
				$display(":) reg2o match at reg[%0d]: %0d", i, reg2o);
		end

		$display("===== RegFile Test Complete =====");
		#10 $finish;
	end

endmodule
