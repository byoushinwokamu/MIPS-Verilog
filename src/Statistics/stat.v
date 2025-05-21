module counter32 (
	output reg [31:0] q,
	input clk, cnten, rst
);
	always @(posedge clk or posedge rst) begin
		if (rst) q <= 32'b0;
		else if (cnten) q <= q + 1;
	end

endmodule

module Statistics (
	output [31:0] J,
	output [31:0] R,
	output [31:0] I,
	output [31:0] TotalCycles,
	input clk,
	input [5:0] op,
	input rst
);
	wire j, r, i;
	counter32 jcnt (.q(J), .clk, .cnten(j), .rst);
	counter32 rcnt (.q(R), .clk, .cnten(r), .rst);
	counter32 icnt (.q(I), .clk, .cnten(i), .rst);
	counter32 ccnt (.q(TotalCycles), .clk, .cnten(1'b1), .rst);

	// OPcode Decoding
	wire wi [1:10];
	and (wi[1], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wi[2], op[5], ~op[4], op[3], ~op[2], op[1], op[0]);
	and (wi[3], ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);
	and (wi[4], ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);
	and (wi[5], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
	and (wi[6], ~op[5], ~op[4], op[3], op[2], ~op[1], op[0]);
	and (wi[7], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
	and (wi[8], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wi[9], ~op[5], ~op[4], op[3], ~op[2], ~op[1], op[0]);
	and (wi[10], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	or (
		i, wi[1], wi[2], wi[3], wi[4], wi[5], 
		wi[6], wi[7], wi[8], wi[9], wi[10]
	);

	and (r, ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);

	wire wj [1:2];
	and (wj[1], ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0]);
	and (wj[2], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	or (j, wj[1], wj[2]);

endmodule

module Statistics_tb;
	reg clk, rst;
	reg [5:0] op;
	wire [31:0] J, R, I, TotalCycles;

	Statistics inst (
		.J(J), .R(R), .I(I), .TotalCycles(TotalCycles),
		.clk(clk), .op(op), .rst(rst)
	);

	initial clk = 0;
	always #5 clk = ~clk;

	task tick;
		begin #10; end
	endtask

	task apply_op(input [5:0] opcode, input [255:0] label);
		begin
			op = opcode;
			tick();
			$display("[%s] op = %b | R=%0d, I=%0d, J=%0d, Total=%0d",
								label, op, R, I, J, TotalCycles);
		end
	endtask

	initial begin
		$display("=== Statistics Test ===");

		// 초기화
		rst = 1; tick(); rst = 0; tick();

		// R-type
		apply_op(6'b000000, "R-type");

		// I-type (wi[1] ~ wi[10])
		apply_op(6'b100011, "lw");     // wi[1]
		apply_op(6'b101011, "sw");     // wi[2]
		apply_op(6'b000101, "bne");    // wi[3]
		apply_op(6'b000100, "beq");    // wi[4]
		apply_op(6'b001101, "ori");    // wi[6]
		apply_op(6'b001010, "slti");   // wi[7]
		apply_op(6'b001000, "addi");   // wi[8]
		apply_op(6'b001001, "addiu");  // wi[9]
		apply_op(6'b001000, "addi again"); // wi[10] (중복)

		// J-type (wj[1], wj[2])
		apply_op(6'b000010, "j");
		apply_op(6'b000011, "jal");

		// 여유 tick
		// tick();

		// 최종 결과
		$display("Final: R=%0d, I=%0d, J=%0d, Total=%0d", R, I, J, TotalCycles);
		$display("=== Done ===");
		#10 $finish;
	end

endmodule
