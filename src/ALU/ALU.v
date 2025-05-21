module ALU (result1, result2, OF, CF, Equal, sr, tg, ALUop);
	output [31:0] result1;
	output [31:0] result2;
	output OF, CF, Equal;
	input [31:0] sr;
	input [31:0] tg;
	input [3:0] ALUop;

	wire [31:0] res [15:0];
	wire [31:0] res2 [15:0];
	wire [1:0] OCF [15:0];
	ShiftLeftLogic sll (.res(res[0]), .tg(sr), .sh(tg[4:0]));
	ShiftRightArith sra (.res(res[1]), .tg(sr), .sh(tg[4:0]));
	ShiftRightLogic srl (.res(res[2]), .tg(sr), .sh(tg[4:0]));
	Mul mul (.res(res[3]), .cout(res2[3]), .sr, .tg, .cin(1'b0));
	Div div (.res(res[4]), .rem(res2[4]), .sr, .tg, .upper(1'b0));
	Add add (.res(res[5]), .CF(OCF[5][0]), .OF(OCF[5][1]), .sr, .tg, .cin(1'b0));
	Sub sub (.res(res[6]), .CF(OCF[6][0]), .OF(OCF[6][1]), .sr, .tg, .bin(1'b0));
	and andinst [31:0] (res[7], sr, tg);
	or orinst [31:0] (res[8], sr, tg);
	xor xorinst [31:0] (res[9], sr, tg);
	nor norinst [31:0] (res[10], sr, tg);
	wire wlt, wltu;
	LessThan lt (.lt(wlt), .sr, .tg);
	LessThanUnsigned ltu (.lt(wltu), .eq(Equal), .sr, .tg);
	assign res[11] = {31'b0, wlt};
	assign res[12] = {31'b0, wltu};

	assign result1 = res[ALUop];
	assign result2 = res2[ALUop];
	assign OF = OCF[ALUop][1];
	assign CF = OCF[ALUop][0];

endmodule

module ALU_tb;
	reg [31:0] sr, tg;
	reg [3:0] ALUop;
	wire [31:0] result1, result2;
	wire OF, CF, Equal;

	ALU inst (
		.result1(result1), .result2(result2),
		.OF(OF), .CF(CF), .Equal(Equal),
		.sr(sr), .tg(tg), .ALUop(ALUop)
	);

	task test;
		input [3:0] op;
		input [31:0] a, b;
		begin
			ALUop = op;
			sr = a;
			tg = b;
			#1;
			$display("[ALUop %2d] sr = 0x%08X, tg = 0x%08X", ALUop, sr, tg);
			$display("  → result1 = 0x%08X, result2 = 0x%08X, OF = %b, CF = %b, Equal = %b",
					result1, result2, OF, CF, Equal);
			$display("--------------------------------------------------------");
		end
	endtask

	initial begin
		$display("=== ALU Test ===");

		test(0, 32'h00000001, 32'd4);   // sll
		test(1, 32'hF0000000, 32'd4);   // sra
		test(2, 32'hF0000000, 32'd4);   // srl

		test(3, 32'h00000010, 32'h00000004); // mul: 16 × 4 = 64

		test(4, 32'h00000010, 32'h00000003); // div: 16 / 3 = 5, rem = 1

		test(5, 32'h7FFFFFFF, 32'd1);   // add: overflow 발생
		test(6, 32'h80000000, 32'd1);   // sub: overflow 발생

		test(7, 32'hFF00FF00, 32'h0F0F0F0F); // and
		test(8, 32'hF0000000, 32'h0000FFFF); // or
		test(9, 32'hAAAA5555, 32'hFFFF0000); // xor
		test(10, 32'h00000000, 32'h00000000); // nor

		test(11, -5, 3);                // signed comp: 1
		test(11, 5, -3);                // signed comp: 0

		test(12, 32'h00000001, 32'hFFFFFFFF); // unsigned comp: 1
		test(12, 32'hFFFFFFFF, 32'h00000001); // unsigned comp: 0

		$display("=== Test Done ===");
		#10 $finish;
	end

endmodule