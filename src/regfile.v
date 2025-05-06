module RegFile (reg1o, reg2o, reg1n, reg2n, wregn, wdata, wen, clk, reset);
	output [31:0] reg1o;
	output [31:0] reg2o;
	input [4:0] reg1n;
	input [4:0] reg2n;
	input [4:0] wregn;
	input [31:0] wdata;
	input wen, clk, reset;

	// Select register to write data
	wire [3:0] wsel_demux;
	wire [31:0] wsel_reg;
	demux4 wsel_upper (.out(wsel_demux), .in(1'b1), .en(wen), .sel(wregn[4:3]));
	demux8 wsel_lower0 (.out(wsel_reg[7:0]), .in(1'b1), .en(wsel_demux[0]), .sel(wregn[2:0]));
	demux8 wsel_lower1 (.out(wsel_reg[15:8]), .in(1'b1), .en(wsel_demux[1]), .sel(wregn[2:0]));
	demux8 wsel_lower2 (.out(wsel_reg[23:16]), .in(1'b1), .en(wsel_demux[2]), .sel(wregn[2:0]));
	demux8 wsel_lower3 (.out(wsel_reg[31:24]), .in(1'b1), .en(wsel_demux[3]), .sel(wregn[2:0]));

	// Instantiate registers
	wire [31:0] regout0;	wire [31:0] regout1;
	wire [31:0] regout2;	wire [31:0] regout3;
	wire [31:0] regout4;	wire [31:0] regout5;
	wire [31:0] regout6;	wire [31:0] regout7;
	wire [31:0] regout8;	wire [31:0] regout9;
	wire [31:0] regout10;	wire [31:0] regout11;
	wire [31:0] regout12;	wire [31:0] regout13;
	wire [31:0] regout14;	wire [31:0] regout15;
	wire [31:0] regout16;	wire [31:0] regout17;
	wire [31:0] regout18;	wire [31:0] regout19;
	wire [31:0] regout20;	wire [31:0] regout21;
	wire [31:0] regout22;	wire [31:0] regout23;
	wire [31:0] regout24;	wire [31:0] regout25;
	wire [31:0] regout26;	wire [31:0] regout27;
	wire [31:0] regout28;	wire [31:0] regout29;
	wire [31:0] regout30; wire [31:0] regout31;

	assign regout0 = 32'b0; // Hard-wired zero register
	reg32 regat (.readdata(regout1), .writedata(wdata), .clk(clk), .wen(wsel_reg[1]), .reset(reset));
	reg32 regv0 (.readdata(regout2), .writedata(wdata), .clk(clk), .wen(wsel_reg[2]), .reset(reset));
	reg32 regv1 (.readdata(regout3), .writedata(wdata), .clk(clk), .wen(wsel_reg[3]), .reset(reset));
	reg32 rega0 (.readdata(regout4), .writedata(wdata), .clk(clk), .wen(wsel_reg[4]), .reset(reset));
	reg32 rega1 (.readdata(regout5), .writedata(wdata), .clk(clk), .wen(wsel_reg[5]), .reset(reset));
	reg32 rega2 (.readdata(regout6), .writedata(wdata), .clk(clk), .wen(wsel_reg[6]), .reset(reset));
	reg32 rega3 (.readdata(regout7), .writedata(wdata), .clk(clk), .wen(wsel_reg[7]), .reset(reset));
	reg32 regt0 (.readdata(regout8), .writedata(wdata), .clk(clk), .wen(wsel_reg[8]), .reset(reset));
	reg32 regt1 (.readdata(regout9), .writedata(wdata), .clk(clk), .wen(wsel_reg[9]), .reset(reset));
	reg32 regt2 (.readdata(regout10), .writedata(wdata), .clk(clk), .wen(wsel_reg[10]), .reset(reset));
	reg32 regt3 (.readdata(regout11), .writedata(wdata), .clk(clk), .wen(wsel_reg[11]), .reset(reset));
	reg32 regt4 (.readdata(regout12), .writedata(wdata), .clk(clk), .wen(wsel_reg[12]), .reset(reset));
	reg32 regt5 (.readdata(regout13), .writedata(wdata), .clk(clk), .wen(wsel_reg[13]), .reset(reset));
	reg32 regt6 (.readdata(regout14), .writedata(wdata), .clk(clk), .wen(wsel_reg[14]), .reset(reset));
	reg32 regt7 (.readdata(regout15), .writedata(wdata), .clk(clk), .wen(wsel_reg[15]), .reset(reset));
	reg32 regs0 (.readdata(regout16), .writedata(wdata), .clk(clk), .wen(wsel_reg[16]), .reset(reset));
	reg32 regs1 (.readdata(regout17), .writedata(wdata), .clk(clk), .wen(wsel_reg[17]), .reset(reset));
	reg32 regs2 (.readdata(regout18), .writedata(wdata), .clk(clk), .wen(wsel_reg[18]), .reset(reset));
	reg32 regs3 (.readdata(regout19), .writedata(wdata), .clk(clk), .wen(wsel_reg[19]), .reset(reset));
	reg32 regs4 (.readdata(regout20), .writedata(wdata), .clk(clk), .wen(wsel_reg[20]), .reset(reset));
	reg32 regs5 (.readdata(regout21), .writedata(wdata), .clk(clk), .wen(wsel_reg[21]), .reset(reset));
	reg32 regs6 (.readdata(regout22), .writedata(wdata), .clk(clk), .wen(wsel_reg[22]), .reset(reset));
	reg32 regs7 (.readdata(regout23), .writedata(wdata), .clk(clk), .wen(wsel_reg[23]), .reset(reset));
	reg32 regt8 (.readdata(regout24), .writedata(wdata), .clk(clk), .wen(wsel_reg[24]), .reset(reset));
	reg32 regt9 (.readdata(regout25), .writedata(wdata), .clk(clk), .wen(wsel_reg[25]), .reset(reset));
	reg32 regk0 (.readdata(regout26), .writedata(wdata), .clk(clk), .wen(wsel_reg[26]), .reset(reset));
	reg32 regk1 (.readdata(regout27), .writedata(wdata), .clk(clk), .wen(wsel_reg[27]), .reset(reset));
	reg32 reggp (.readdata(regout28), .writedata(wdata), .clk(clk), .wen(wsel_reg[28]), .reset(reset));
	reg32 regsp (.readdata(regout29), .writedata(wdata), .clk(clk), .wen(wsel_reg[29]), .reset(reset));
	reg32 regfp (.readdata(regout30), .writedata(wdata), .clk(clk), .wen(wsel_reg[30]), .reset(reset));
	reg32 regra (.readdata(regout31), .writedata(wdata), .clk(clk), .wen(wsel_reg[31]), .reset(reset));

	// Select register to read data
	mux32x32 rsel1 (.out(reg1o), 
		.in0(regout0),   .in1(regout1),
		.in2(regout2),   .in3(regout3),
		.in4(regout4),   .in5(regout5),
		.in6(regout6),   .in7(regout7),
		.in8(regout8),   .in9(regout9),
		.in10(regout10), .in11(regout11),
		.in12(regout12), .in13(regout13),
		.in14(regout14), .in15(regout15),
		.in16(regout16), .in17(regout17),
		.in18(regout18), .in19(regout19),
		.in20(regout20), .in21(regout21),
		.in22(regout22), .in23(regout23),
		.in24(regout24), .in25(regout25),
		.in26(regout26), .in27(regout27),
		.in28(regout28), .in29(regout29),
		.in30(regout30), .in31(regout31),
		.sel(reg1n));
		
	mux32x32 rsel2 (.out(reg2o), 
		.in0(regout0),   .in1(regout1),
		.in2(regout2),   .in3(regout3),
		.in4(regout4),   .in5(regout5),
		.in6(regout6),   .in7(regout7),
		.in8(regout8),   .in9(regout9),
		.in10(regout10), .in11(regout11),
		.in12(regout12), .in13(regout13),
		.in14(regout14), .in15(regout15),
		.in16(regout16), .in17(regout17),
		.in18(regout18), .in19(regout19),
		.in20(regout20), .in21(regout21),
		.in22(regout22), .in23(regout23),
		.in24(regout24), .in25(regout25),
		.in26(regout26), .in27(regout27),
		.in28(regout28), .in29(regout29),
		.in30(regout30), .in31(regout31),
		.sel(reg2n));

endmodule
