module CP0_tb;
	reg ExpSrc0, ExpSrc1, ExpSrc2;
	reg clk, enable, reset;
	reg [31:0] Instruction, PCin, Din;
	wire [31:0] PCout, Dout;
	wire ExRegWrite, ExpBlock, IsEret, HasExp;

	CP0 inst (
		.PCout, .Dout, .ExRegWrite, .ExpBlock, .IsEret, .HasExp,
		.ExpSrc0, .ExpSrc1, .ExpSrc2, .clk, .enable,
		.Instruction, .PCin, .Din, .reset
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	task tick(); begin #10; end endtask

	task reset_all();
		begin
			ExpSrc0 = 0; ExpSrc1 = 0; ExpSrc2 = 0;
			enable = 0; reset = 1;
			Instruction = 32'd0;
			PCin = 32'hDEAD_BEEF;
			Din = 32'h1234_5678;
			tick();
			reset = 0;
			tick();
		end
	endtask

	task trigger_exception(input integer src);
		begin
			ExpSrc0 = (src == 0);
			ExpSrc1 = (src == 1);
			ExpSrc2 = (src == 2);
			tick();
			ExpSrc0 = 0; ExpSrc1 = 0; ExpSrc2 = 0;
		end
	endtask

	task write_reg(input [1:0] sel, input [31:0] val);
		begin
			enable = 1;
			Instruction[23] = 0;   // ExRegWrite = ~Instruction[23] → 1
			Instruction[12:11] = sel;
			Din = val;
			tick();
			enable = 0;
		end
	endtask

	task read_reg(input [1:0] sel);
		begin
			Instruction[23] = 1;  // ExRegWrite = ~1 = 0 → 읽기 모드
			Instruction[12:11] = sel;
			tick();
			$display("Read CP0[sel=%0d] = 0x%08X", sel, Dout);
		end
	endtask

	task check_eret();
		begin
			Instruction[5:0] = 6'b011000;  // eret opcode
			tick();
			$display("IsEret = %b, PCout = 0x%08X", IsEret, PCout);
		end
	endtask

	initial begin
		$display("=== CP0 Test Start ===");

		reset_all();

		// ▶ Write to Status (sel = 01)
		write_reg(2'b01, 32'h00000001);  // Set Status[0] = 1 → block on
		$display("ExpBlock = %b", ExpBlock);

		// ▶ Trigger exception 0 (ExpSrc0 = 1)
		trigger_exception(0);  // cause should be 0x1
		$display("HasExp = %b", HasExp);
		read_reg(2'b11);       // Cause

		// ▶ EPC 저장 확인 (PCin = 0xDEAD_BEEF)
		read_reg(2'b00);       // EPC
		$display("PCout (EPC) = 0x%08X", PCout);

		// ▶ Block 레지스터에 쓰기
		write_reg(2'b10, 32'hBEEF_BEEF);
		read_reg(2'b10);       // Block

		// ▶ ERET 동작 확인
		check_eret();

		$display("=== CP0 Test Done ===");
		#20 $finish;
	end

endmodule
