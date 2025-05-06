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
	wire [31:0] regout [31:0];
	// assign regout[0] = 32'b0; // Hard-wired Zero register
	reg32 regs [31:0] (.readdata(regout), .writedata(wdata), .clk(clk), .wen({wsel_reg[31:1], 1'b0}), .reset(reset));
	// reg32 regs1 (.readdata(regout[1]), .writedata(wdata), .clk(clk), .wen(wsel_reg[1]), reset(reset));


	// Select register to read data
	mux32x32 rsel1 (.out(reg1o), .in(regout), .sel(reg1n));
	// mux32x32 rsel2 (.out(reg2o), .in(regout), .sel(reg2n));

endmodule
