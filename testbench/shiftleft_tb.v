module ShiftLeftLogic_tb;
	reg [31:0] tg;
	reg [4:0] sh;
	wire [31:0] res;

	ShiftLeftLogic inst (
		.res(res),
		.tg(tg),
		.sh(sh)
	);

	task test;
		input [31:0] tg_in;
		input [4:0] shamt;
		begin
			tg = tg_in;
			sh = shamt;
			#1; // combinational delay
			$display("tg = 0x%08X, sh = %2d → res = 0x%08X (expected 0x%08X)", 
								tg, sh, res, tg << sh);
		end
	endtask

	initial begin
		$display("=== ShiftLeftLogic Test ===");

			test(32'h00000001, 1);  // 0x00000002
			test(32'h00000001, 4);  // 0x00000010
			test(32'hF0000000, 1);  // 0xE0000000
			test(32'h0000FFFF, 8);  // 0x00FFFF00
			test(32'hFFFFFFFF, 16); // 0xFFFF0000
			test(32'hAAAAAAAA, 3);  // 0x5555540

			$display("=== Test Done ===");
			#10 $finish;
	end

endmodule
