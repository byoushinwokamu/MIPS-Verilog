module SyscallDecoder (
	output Halt,
	output [31:0] Hex,
	input [31:0] v0,
	input [31:0] a0,
	input clk, en, reset
);
	wire compv0;
	assign compv0 = (v0 == 32'hA);
	assign Halt = en ? compv0 : 1'b0;

	reg32 rega0 (.readdata(Hex), .writedata(a0), .clk, .wen(en), .reset);

endmodule

module SyscallDecoder_tb;
	reg [31:0] v0, a0;
	reg clk, en, reset;
	wire Halt;
	wire [31:0] Hex;

	SyscallDecoder inst (
		.Halt(Halt),
		.Hex(Hex),
		.v0(v0),
		.a0(a0),
		.clk(clk),
		.en(en),
		.reset(reset)
	);

	initial clk = 0;
	always #5 clk = ~clk;

	task tick;
		begin #10; end
	endtask

	task run_syscall(input [31:0] v, input [31:0] a);
		begin
			v0 = v;
			a0 = a;
			en = 1;
			tick();
			$display("Syscall v0=%0d, a0=0x%08X → Halt=%b, Hex=0x%08X", v0, a0, Halt, Hex);
			en = 0;
			tick();
		end
	endtask

	initial begin
		$display("=== SyscallDecoder Test ===");

		// 초기화
		v0 = 0; a0 = 0; en = 0; reset = 1; tick(); reset = 0; tick();

		// 정상 syscall (v0 = 1), should not halt
		run_syscall(1, 32'h12345678);

		// 종료 syscall (v0 = 10)
		run_syscall(10, 32'hABCD1234);

		// en = 0 (disabled) → 아무것도 안 해야 함
		v0 = 10; a0 = 32'hFFFFFFFF; en = 0; tick();
		$display("Disabled → Halt=%b, Hex=0x%08X", Halt, Hex);

		$display("=== Done ===");
		#20 $finish;
	end

endmodule
