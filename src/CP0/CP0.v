module CP0 (
	output [31:0] PCout,
	output [31:0] Dout,
	output ExRegWrite, ExpBlock, IsEret, HasExp,
	input ExpSrc0, ExpSrc1, ExpSrc2, clk, enable,
	input [31:0] Instruction,
	input [31:0] PCin,
	input [31:0] Din,
	input reset
);
	wire [1:0] sel;
	wire BlockSrc0, BlockSrc1, BlockSrc2;
	wire wes1, wes2, wes3, ExpClick;
	wire [31:0] wrm0;
	wire [31:0] wrm1;
	wire [31:0] wrm2;
	wire [31:0] wrm3;
	wire wand0, wand1, wand2, wand3, wdm0, wdm1, wdm2, wor1;

	// Signal Decoding
	assign ExRegWrite = ~Instruction[23];
	assign sel = Instruction[12:11];
	and (
		IsEret, ~Instruction[5], Instruction[4], Instruction[3], 
	  ~Instruction[2], ~Instruction[1], ~Instruction[0]
	);

	// Exception Signals
	or (
		wes1, 
		BlockSrc0 ? 1'b0: ExpSrc0,
		BlockSrc1 ? 1'b0: ExpSrc1,
		BlockSrc2 ? 1'b0: ExpSrc2
	);
	and (ExpClick, wes1, ~ExpBlock);
	counter1 cnt1 (
		.q(wes2), .clk(ExpClick), .clear(wes3), .rst(reset)
	);
	counter1 cnt2 (
		.q(wes3), .clk(HasExp), .clear(~wes2), .rst(reset)
	);
	and (HasExp, clk, wes2);

	// Registers
	wire [31:0] causein;
	assign causein = {29'b0, ExpSrc2, ExpSrc1 | ExpSrc2, ExpSrc0 | ExpSrc1 | ExpSrc2};
	reg32 Cause (.readdata(wrm3), .writedata(causein), .clk(ExpClick), .wen(1'b1), .reset);

	reg32 Block (.readdata(wrm2), .writedata(Din), .clk, .wen(wand3), .reset);
	assign BlockSrc0 = wrm2[0];
	assign BlockSrc1 = wrm2[1];
	assign BlockSrc2 = wrm2[2];

	reg32 Status (.readdata(wrm1), .writedata(Din), .clk, .wen(wand2), .reset);
	assign ExpBlock = wrm1[0];

	and (wand0, enable, ~ExRegWrite);
	assign wdm0 = (sel == 2'b00) ? 1'b1 : 1'b0;
	assign wdm1 = (sel == 2'b01) ? 1'b1 : 1'b0;
	assign wdm2 = (sel == 2'b10) ? 1'b1 : 1'b0;
	and (wand1, wand0, wdm0);
	and (wand2, wand0, wdm1);
	and (wand3, wand0, wdm2);

	or(wor1, HasExp, wand1);
	wire [31:0] epcin;
	assign epcin = (HasExp == 1'b1) ? PCin : Din;
	reg32 EPC (.readdata(wrm0), .writedata(epcin), .clk, .wen(wor1), .reset);

	assign PCout = wrm0;
	assign Dout = (sel[1] == 1'b0) ? ((sel[0] == 1'b0) ? wrm0 : wrm1)
																 : ((sel[0] == 1'b0) ? wrm2 : wrm3);

endmodule

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

module CP0_tb2;
    reg ExpSrc0, ExpSrc1, ExpSrc2;
    reg clk, enable, reset;
    reg [31:0] Instruction, PCin, Din;
    wire [31:0] PCout, Dout;
    wire ExRegWrite, ExpBlock, IsEret, HasExp;

    CP0 dut (
        .PCout, .Dout, .ExRegWrite, .ExpBlock, .IsEret, .HasExp,
        .ExpSrc0, .ExpSrc1, .ExpSrc2, .clk, .enable,
        .Instruction, .PCin, .Din, .reset
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task tick;
        begin #10; end
    endtask

    task reset_all;
        begin
            ExpSrc0 = 0; ExpSrc1 = 0; ExpSrc2 = 0;
            enable = 0; reset = 1;
            Instruction = 0;
            PCin = 32'hDEAD_BEEF;
            Din = 32'h12345678;
            tick();
            reset = 0;
            tick();
        end
    endtask

    task write_cp0(input [1:0] sel, input [31:0] val);
        begin
            enable = 1;
            Instruction[23] = 0;         // ExRegWrite = ~Instruction[23] = 1
            Instruction[12:11] = sel;
            Din = val;
            tick();
            enable = 0;
        end
    endtask

    task read_cp0(input [1:0] sel);
        begin
            Instruction[23] = 1;         // ExRegWrite = 0
            Instruction[12:11] = sel;
            tick();
            $display("Dout[sel=%0d] = 0x%08X", sel, Dout);
        end
    endtask

    task trigger_exp(input integer idx);
        begin
            if (idx == 0) ExpSrc0 = 1;
            else if (idx == 1) ExpSrc1 = 1;
            else if (idx == 2) ExpSrc2 = 1;
            tick();
            ExpSrc0 = 0; ExpSrc1 = 0; ExpSrc2 = 0;
            tick();  // propagate
        end
    endtask

    task check_eret;
        begin
            Instruction[5:0] = 6'b011000;  // eret pattern
            tick();
            $display("IsEret = %b, PCout = 0x%08X", IsEret, PCout);
        end
    endtask

    initial begin
        $display("=== CP0 Test Start ===");

        reset_all();

        // Status[0] = 1 (ExpBlock = 1)
        write_cp0(2'b01, 32'h00000001);
        $display("ExpBlock = %b", ExpBlock);

        // Block = 0x00000007 (BlockSrc0/1/2 = 1)
        write_cp0(2'b10, 32'h00000007);

        // Exception from ExpSrc0 → BlockSrc0 = 1 → 무시되어야 함
        trigger_exp(0);
        $display("Blocked ExpSrc0 → HasExp = %b", HasExp);

        // Block = 0x00000000 (모두 허용)
        write_cp0(2'b10, 32'h00000000);

        // Exception from ExpSrc1 → Cause = 0x00000003
        trigger_exp(1);
        $display("ExpSrc1 allowed → HasExp = %b", HasExp);
        read_cp0(2'b11);  // Cause
        read_cp0(2'b00);  // EPC (should be PCin)

        // EPC 직접 쓰기 (sel == 00)
        write_cp0(2'b00, 32'hAABBCCDD);
        read_cp0(2'b00);

        // ERET 명령 디코드
        check_eret();

        $display("=== CP0 Test Done ===");
        #20 $finish;
    end
endmodule
