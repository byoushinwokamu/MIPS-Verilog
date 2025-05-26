module adder1 (sum, cout, a, b, cin);
	output sum, cout;
	input a, b, cin;

	wire xor1, and1, and2;
	xor (xor1, a, b);
	xor (sum, xor1, cin);
	and (and1, xor1, cin);
	and (and2, a, b);
	or (cout, and1, and2);

endmodule

module adder31 (sum, cout, a, b, cin);
	output [30:0] sum;
	output cout;
	input [30:0] a;
	input [30:0] b;
	input cin;

	wire [29:0] c;
	adder1 adders [30:0] (
		.sum, .cout({cout, c}),
		.a, .b, .cin({c, cin})
	);

endmodule

module Add (res, CF, OF, sr, tg, cin);
	output [31:0] res;
	output CF, OF;
	input [31:0] sr;
	input [31:0] tg;
	input cin;

	wire cc;
	adder31 adder_upper (
		.sum(res[30:0]), .cout(cc),
		.a(sr[30:0]), .b(tg[30:0]), .cin(cin)
	);
	adder1 adder_lower (
		.sum(res[31]), .cout(CF),
		.a(sr[31]), .b(tg[31]), .cin(cc)
	);
	xor (OF, cc, CF);

endmodule

`timescale 1ns/1ps

module tb_Add;

	// DUT inputs
	reg [31:0] sr, tg;
	reg cin;

	// DUT outputs
	wire [31:0] res;
	wire CF, OF;

	// Instantiate the Add module
	Add dut (
		.res(res),
		.CF(CF),
		.OF(OF),
		.sr(sr),
		.tg(tg),
		.cin(cin)
	);

	// Task to check result
	task check_result;
		input [31:0] in1, in2;
		input cin_in;
		input [31:0] expected_res;
		input expected_CF;
		input expected_OF;

		begin
			sr = in1;
			tg = in2;
			cin = cin_in;
			#1; // wait for combinational logic

			$display("--------------------------------------------------");
			$display("Input A       = 0x%h", sr);
			$display("Input B       = 0x%h", tg);
			$display("Cin           = %b", cin);
			$display("Expected Res  = 0x%h", expected_res);
			$display("Actual Res    = 0x%h", res);
			$display("Expected CF   = %b, Actual CF = %b", expected_CF, CF);
			$display("Expected OF   = %b, Actual OF = %b", expected_OF, OF);
			$display("Result %s", (res === expected_res && CF === expected_CF && OF === expected_OF) ? "✔ PASS" : "✘ FAIL");
		end
	endtask

	initial begin
		// Test Case 1: Simple addition without carry
		check_result(32'h00000001, 32'h00000001, 1'b0, 32'h00000002, 1'b0, 1'b0);

		// Test Case 2: With carry-in
		check_result(32'h00000001, 32'h00000001, 1'b1, 32'h00000003, 1'b0, 1'b0);

		// Test Case 3: Carry out (unsigned overflow)
		check_result(32'hFFFFFFFF, 32'h00000001, 1'b0, 32'h00000000, 1'b1, 1'b0);

		// Test Case 4: Signed overflow (positive + positive = negative)
		check_result(32'h7FFFFFFF, 32'h00000001, 1'b0, 32'h80000000, 1'b0, 1'b1);

		// Test Case 5: Signed overflow (negative + negative = positive)
		check_result(32'h80000000, 32'h80000000, 1'b0, 32'h00000000, 1'b1, 1'b1);

		// Test Case 6: Random mid-range values
		check_result(32'h12345678, 32'h11111111, 1'b0, 32'h23456789, 1'b0, 1'b0);

		$display("--------------------------------------------------");
		$display("All test cases finished.");
		$finish;
	end

endmodule

