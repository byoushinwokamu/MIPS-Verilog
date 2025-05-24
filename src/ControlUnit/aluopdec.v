module ALUopDecoder(
	output [3:0] ALUop,
	input [5:0] op
);
	// ALUop[3]
	wire wa [1:2];
	and (wa[1], ~op[5], ~op[4], op[3], op[2], ~op[1], op[0]);
	and (wa[2], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
	or (ALUop[3], wa[1], wa[2]);

	// ALUop[2]
	wire wb [1:12];
	and (wb[1], ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	and (wb[2], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wb[3], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wb[4], op[5], ~op[4], op[3], ~op[2], op[1], op[0]);
	and (wb[5], ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);
	and (wb[6], ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);
	and (wb[7], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
	and (wb[8], ~op[5], ~op[4], op[3], ~op[2], ~op[1], op[0]);
	and (wb[9], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wb[10], ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0]);
	and (wb[11], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wb[12], ~op[5], op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	or (
		ALUop[2], wb[1], wb[2], wb[3], wb[4], wb[5], wb[6], 
		wb[7], wb[8], wb[9], wb[10], wb[11], wb[12]
	);

	// ALUop[1]
	wire wc [1:2];
	and (wc[1], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
	and (wc[2], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
	or (ALUop[1], wc[1], wc[2]);

	// ALUop[0]
	wire wd [1:13];
	and (wd[1], ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	and (wd[2], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wd[3], op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wd[4], op[5], ~op[4], op[3], ~op[2], op[1], op[0]);
	and (wd[5], ~op[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);
	and (wd[6], ~op[5], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);
	and (wd[7], ~op[5], ~op[4], op[3], op[2], ~op[1], ~op[0]);
	and (wd[8], ~op[5], ~op[4], op[3], ~op[2], op[1], ~op[0]);
	and (wd[9], ~op[5], ~op[4], op[3], ~op[2], ~op[1], op[0]);
	and (wd[10], ~op[5], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);
	and (wd[11], ~op[5], ~op[4], ~op[3], ~op[2], op[1], ~op[0]);
	and (wd[12], ~op[5], ~op[4], ~op[3], ~op[2], op[1], op[0]);
	and (wd[13], ~op[5], op[4], ~op[3], ~op[2], ~op[1], ~op[0]);
	or (
		ALUop[0], wd[1], wd[2], wd[3], wd[4], wd[5], wd[6],
		wd[7], wd[8], wd[9], wd[10], wd[11], wd[12], wd[13]
	);

endmodule

// No independent tb