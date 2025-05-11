module ALUftDecoder (
	output ALU0, ALU1, ALU2, ALU3,
	output IsJR,
	output IsSyscall,
	output IsShamt,
	input ft0, ft1, ft2, ft3, ft4, ft5
);
	// ALU0
	wire wa0 [1:4];
	and (wa0[1], ft0, ~ft1, ~ft2, ft3, ~ft4, ft5);
	and (wa0[2], ft0, ~ft1, ~ft2, ft3, ft4, ft5);
	and (wa0[3], ft0, ~ft1, ft2, ~ft3, ft4, ~ft5);
	and (wa0[4], ft0, ~ft1, ft2, ~ft3, ft4, ft5);
	or (ALU0, wa0[1], wa0[2], wa0[3], wa0[4]);

	// ALU1
	wire wa1 [1:4];
	and (wa1[1], ft0, ~ft1, ~ft2, ~ft3, ~ft4);
	and (wa1[2], ft0, ~ft1, ~ft2, ~ft3, ~ft5);
	and (wa1[3], ft0, ~ft1, ~ft2, ~ft4, ~ft5);
	and (wa1[4], ft0, ~ft1, ft2, ~ft3, ft4, ft5);
	or (ALU1, wa1[1], wa1[2], wa1[3], wa1[4]);

	// ALU2
	wire wa2 [1:5];
	and (wa2[1], ft0, ~ft1, ~ft2, ~ft3, ft4, ~ft5);
	and (wa2[2], ft0, ~ft1, ~ft2, ft3, ~ft4, ~ft5);
	and (wa2[3], ~ft0, ~ft1, ~ft2, ~ft3, ft4, ~ft5);
	and (wa2[4], ft0, ~ft1, ~ft2, ft3, ft4, ft5);
	and (wa2[5], ft0, ~ft1, ft2, ~ft3, ft4, ~ft5);
	or (ALU2, wa2[1], wa2[2], wa2[3], wa2[4], wa2[5]);

	// ALU3
	wire wa3 [1:4];
	and (wa3[1], ~ft0, ~ft1, ~ft2, ~ft3, ft4, ft5);
	and (wa3[2], ft0, ~ft1, ~ft2, ~ft3, ~ft4);
	and (wa3[3], ft0, ~ft1, ~ft2, ~ft4, ~ft5);
	and (wa3[4], ft0, ~ft1, ft2, ~ft3, ft4, ~ft5);
	or (ALU3, wa3[1], wa3[2], wa3[3], wa3[4]);

	// IsJR
	and (IsJR, ~ft0, ~ft1, ft2, ~ft3, ~ft4, ~ft5);

	// IsSyscall
	and (IsSyscall, ~ft0, ~ft1, ft2, ft3, ~ft4, ~ft5);

	// IsShamt
	wire wsh [1:3];
	and (wsh[1], ~ft0, ~ft1, ~ft2, ~ft3, ft4, ft5);
	and (wsh[2], ~ft0, ~ft1, ~ft2, ~ft3, ft4, ~ft5);
	and (wsh[3], ~ft0, ~ft1, ~ft2, ~ft3, ~ft4, ~ft5);
	or (IsShamt, wsh[1], wsh[2], wsh[3]);

endmodule