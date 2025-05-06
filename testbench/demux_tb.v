module demux48_tb;
	reg [2:0] sel;
	reg in, en;
	wire [3:0] out4;
	wire [7:0] out8;

	demux4 d4(out4, in, en, sel[1:0]);
	demux8 d8(out8, in, en, sel[2:0]);

	initial begin
		sel <= 3'b0;
		in <= 1'b1;
		en <= 1'b0;

		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 en <= 1'b1; sel <= 3'b0;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;

		#10 $finish;
	end

endmodule