module ImmediateExtender (
	output [31:0] out,
	input [15:0] in,
	input ZeroExtend
);
	assign out[15:0] = in;
	assign out[31:16] = ZeroExtend ? 16'b0 : {16{in[15]}};

endmodule

module ImmediateExtender_tb;
	reg [15:0] in;
	reg ZeroExtend;
	wire [31:0] out;

	ImmediateExtender dut (
		.out(out),
		.in(in),
		.ZeroExtend(ZeroExtend)
	);

	task test(input [15:0] imm, input ze);
		begin
			in = imm;
			ZeroExtend = ze;
			#1;
			$display("in = 0x%04X, ZeroExtend = %b → out = 0x%08X", in, ZeroExtend, out);
		end
	endtask

	initial begin
		$display("=== ImmediateExtender Test ===");

		// Positive value (sign bit = 0)
		test(16'h1234, 0);  // Sign extend
		test(16'h1234, 1);  // Zero extend

		// Negative value (sign bit = 1)
		test(16'hF234, 0);  // Sign extend
		test(16'hF234, 1);  // Zero extend

		// Edge case: sign bit 1 but value = 0xFFFF
		test(16'hFFFF, 0);  // Sign extend → 0xFFFFFFFF
		test(16'hFFFF, 1);  // Zero extend → 0x0000FFFF

		$display("=== Done ===");
		#5 $finish;
	end

endmodule