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

	assign OCF[0] = 2'b0;
	assign OCF[1] = 2'b0;
	assign OCF[2] = 2'b0;
	assign OCF[3] = 2'b0;
	assign OCF[4] = 2'b0;
	assign OCF[7] = 2'b0;
	assign OCF[8] = 2'b0;
	assign OCF[9] = 2'b0;
	assign OCF[10] = 2'b0;
	assign OCF[11] = 2'b0;
	assign OCF[12] = 2'b0;
	assign OCF[13] = 2'b0;
	assign OCF[14] = 2'b0;
	assign OCF[15] = 2'b0;
	assign res2[0] = 32'b0;
	assign res2[1] = 32'b0;
	assign res2[2] = 32'b0;
	assign res2[5] = 32'b0;
	assign res2[6] = 32'b0;
	assign res2[7] = 32'b0;
	assign res2[8] = 32'b0;
	assign res2[9] = 32'b0;
	assign res2[10] = 32'b0;
	assign res2[11] = 32'b0;
	assign res2[12] = 32'b0;
	assign res2[13] = 32'b0;
	assign res2[14] = 32'b0;
	assign res2[15] = 32'b0;

endmodule

module tb_ALU;

    reg [31:0] sr, tg;
    reg [3:0] ALUop;
    wire [31:0] result1, result2;
    wire OF, CF, Equal;

    ALU dut (
        .result1(result1), .result2(result2), .OF(OF), .CF(CF), .Equal(Equal),
        .sr(sr), .tg(tg), .ALUop(ALUop)
    );

    task test;
        input [8*20:1] op_name;
        input [31:0] s, t;
        input [3:0] op;
        input [31:0] exp_result1;
        input [31:0] exp_result2;
        input exp_OF, exp_CF;

        begin
            sr = s;
            tg = t;
            ALUop = op;
            #1;
            $display("==== ALUop: %s ====", op_name);
            $display("Inputs sr = %h, tg = %h", sr, tg);
            $display("Result1  = %h (expected %h) %s", result1, exp_result1, (result1 === exp_result1) ? "OK" : "MISMATCH");
            $display("Result2  = %h (expected %h) %s", result2, exp_result2, (result2 === exp_result2) ? "OK" : "MISMATCH");
            $display("OF = %b (exp %b) %s", OF, exp_OF, (OF === exp_OF) ? "OK" : "MISMATCH");
            $display("CF = %b (exp %b) %s", CF, exp_CF, (CF === exp_CF) ? "OK" : "MISMATCH");
            $display("");
        end
    endtask

    initial begin
        // sll edge cases
        test("sll_zero", 32'h00000001, 32'h00000000, 4'd0, 32'h00000001, 32'h00000000, 0, 0);
        test("sll_maxshift", 32'h00000001, 32'h0000001F, 4'd0, 32'h80000000, 32'h00000000, 0, 0);

        // sra edge cases
        test("sra_pos", 32'h7FFFFFFF, 32'd1, 4'd1, 32'h3FFFFFFF, 32'h00000000, 0, 0);
        test("sra_neg", 32'hFFFFFFFF, 32'd1, 4'd1, 32'hFFFFFFFF, 32'h00000000, 0, 0);

        // srl edge cases
        test("srl_pos", 32'h80000000, 32'd1, 4'd2, 32'h40000000, 32'h00000000, 0, 0);

        // add + overflow
        test("add_overflow", 32'h7FFFFFFF, 32'h00000001, 4'd5, 32'h80000000, 32'h00000000, 1, 0);

        // sub - underflow
        test("sub_underflow", 32'h00000000, 32'h00000001, 4'd6, 32'hFFFFFFFF, 32'h00000000, 1, 1);

        // mul
        test("mul_basic", 32'h00000010, 32'h00000010, 4'd3, 32'h00000100, 32'h00000000, 0, 0);

        // div
        test("div_basic", 32'd7, 32'd3, 4'd4, 32'd2, 32'd1, 0, 0);

        // and, or, xor, nor
        test("and_basic", 32'hF0F0F0F0, 32'h0F0F0F0F, 4'd7, 32'h00000000, 32'h00000000, 0, 0);
        test("or_basic", 32'hF0F0F0F0, 32'h0F0F0F0F, 4'd8, 32'hFFFFFFFF, 32'h00000000, 0, 0);
        test("xor_basic", 32'hAAAA5555, 32'hFFFF0000, 4'd9, 32'h55555555, 32'h00000000, 0, 0);
        test("nor_basic", 32'h00000000, 32'hFFFFFFFF, 4'd10, 32'h00000000, 32'h00000000, 0, 0);

        // slt: signed comparison
        test("slt_true", 32'd1, -32'sd1, 4'd11, 32'd0, 32'd0, 0, 0);
        test("slt_false", -32'sd1, 32'd1, 4'd11, 32'd1, 32'd0, 0, 0);

        // sltu: unsigned comparison
        test("sltu_true", 32'h00000001, 32'hFFFFFFFF, 4'd12, 32'd1, 32'd0, 0, 0);
        test("sltu_false", 32'hFFFFFFFF, 32'h00000001, 4'd12, 32'd0, 32'd0, 0, 0);

        $display("All ALU tests completed.");
        $finish;
    end

endmodule
