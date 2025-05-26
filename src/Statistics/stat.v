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

module tb_Statistics;

  reg clk, rst;
  reg [5:0] op;
  wire [31:0] J, R, I, TotalCycles;

  Statistics dut (
    .J(J), .R(R), .I(I), .TotalCycles(TotalCycles),
    .clk(clk), .op(op), .rst(rst)
  );

  task tick;
    begin
      #1 clk = 1;
      #1 clk = 0;
    end
  endtask

  task test_op;
    input [5:0] opcode;
    input [31:0] exp_j, exp_r, exp_i, exp_cycles;
    input [8*20:1] label;
    begin
      op = opcode;
      tick();
      $display("[%s] opcode = %b", label, opcode);
      $display("    J = %d (expected %d) %s", J, exp_j, (J == exp_j) ? "OK" : "MISMATCH");
      $display("    R = %d (expected %d) %s", R, exp_r, (R == exp_r) ? "OK" : "MISMATCH");
      $display("    I = %d (expected %d) %s", I, exp_i, (I == exp_i) ? "OK" : "MISMATCH");
      $display("    TotalCycles = %d (expected %d) %s", TotalCycles, exp_cycles, (TotalCycles == exp_cycles) ? "OK" : "MISMATCH");
    end
  endtask

  initial begin
    clk = 0;
    rst = 1;
    tick();
    rst = 0;

    // First instruction: R-type
    test_op(6'b000000, 0, 1, 0, 1, "R-type 1");

    // J-type: j (000010)
    test_op(6'b000010, 1, 1, 0, 2, "J-type j");

    // J-type: jal (000011)
    test_op(6'b000011, 2, 1, 0, 3, "J-type jal");

    // I-type: addi (001000)
    test_op(6'b001000, 2, 1, 1, 4, "I-type addi");

    // I-type: lw (100011)
    test_op(6'b100011, 2, 1, 2, 5, "I-type lw");

    // R-type again
    test_op(6'b000000, 2, 2, 2, 6, "R-type 2");

    // Reset check
    rst = 1;
    tick();
    rst = 0;
    $display("[Reset] All counts reset");
    $display("    J = %d (expected 0) %s", J, (J == 0) ? "OK" : "MISMATCH");
    $display("    R = %d (expected 0) %s", R, (R == 0) ? "OK" : "MISMATCH");
    $display("    I = %d (expected 0) %s", I, (I == 0) ? "OK" : "MISMATCH");
    $display("    TotalCycles = %d (expected 0) %s", TotalCycles, (TotalCycles == 0) ? "OK" : "MISMATCH");

    $display("Statistics tests completed.");
    $finish;
  end
endmodule