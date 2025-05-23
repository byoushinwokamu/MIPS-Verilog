module ALUftDecoder (
	output [3:0] ALUop,
	output IsJR,
	output IsSyscall,
	output IsShamt,
	input [5:0] ft
);
	// ALUop[3]
	wire wa0 [1:4];
	and (wa0[1], ft[5], ~ft[4], ~ft[3], ft[2], ~ft[1], ft[0]);
	and (wa0[2], ft[5], ~ft[4], ~ft[3], ft[2], ft[1], ft[0]);
	and (wa0[3], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wa0[4], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ft[0]);
	or (ALUop[3], wa0[1], wa0[2], wa0[3], wa0[4]);

	// ALUop[2]
	wire wa1 [1:4];
	and (wa1[1], ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1]);
	and (wa1[2], ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[0]);
	and (wa1[3], ft[5], ~ft[4], ~ft[3], ~ft[1], ~ft[0]);
	and (wa1[4], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ft[0]);
	or (ALUop[2], wa1[1], wa1[2], wa1[3], wa1[4]);

	// ALUop[1]
	wire wa2 [1:5];
	and (wa2[1], ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wa2[2], ft[5], ~ft[4], ~ft[3], ft[2], ~ft[1], ~ft[0]);
	and (wa2[3], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wa2[4], ft[5], ~ft[4], ~ft[3], ft[2], ft[1], ft[0]);
	and (wa2[5], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ~ft[0]);
	or (ALUop[1], wa2[1], wa2[2], wa2[3], wa2[4], wa2[5]);

	// ALUop[0]
	wire wa3 [1:4];
	and (wa3[1], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ft[0]);
	and (wa3[2], ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1]);
	and (wa3[3], ft[5], ~ft[4], ~ft[3], ~ft[1], ~ft[0]);
	and (wa3[4], ft[5], ~ft[4], ft[3], ~ft[2], ft[1], ~ft[0]);
	or (ALUop[0], wa3[1], wa3[2], wa3[3], wa3[4]);

	// IsJR
	and (IsJR, ~ft[5], ~ft[4], ft[3], ~ft[2], ~ft[1], ~ft[0]);

	// IsSyscall
	and (IsSyscall, ~ft[5], ~ft[4], ft[3], ft[2], ~ft[1], ~ft[0]);

	// IsShamt
	wire wsh [1:3];
	and (wsh[1], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ft[0]);
	and (wsh[2], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ft[1], ~ft[0]);
	and (wsh[3], ~ft[5], ~ft[4], ~ft[3], ~ft[2], ~ft[1], ~ft[0]);
	or (IsShamt, wsh[1], wsh[2], wsh[3]);

endmodule

// No independent tb