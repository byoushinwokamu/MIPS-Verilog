module RegFile_tb;
	wire [31:0] reg1o;
	wire [31:0] reg2o;
	reg [4:0] reg1n;
	reg [4:0] reg2n;
	reg [4:0] wregn;
	reg [31:0] wdata;
	reg wen, clk, reset;
	RegFile inst(reg1o, reg2o, reg1n, reg2n, wregn, wdata, wen, clk, reset);

	always #5 clk = ~clk;

	initial begin
		reg1n <= 0; reg2n <= 0; wregn <= 0; wdata <= 0;
		wen <= 0; clk <= 0; reset <= 0;
		#5 reset <= 1;
		#5 reset <= 0;

		#10 wen <= 0; reg1n <= 5'd20; reg2n <= 5'd10;
		#10 wen <= 0; reg1n <= 5'd0; reg2n <= 5'd0;

		#10 wen <= 1; wregn <= 5'd1; wdata <= 32'd1;
		#10 wregn <= 5'd2;  wdata <= 32'd2;
		#10 wregn <= 5'd3;  wdata <= 32'd3;
		#10 wregn <= 5'd4;  wdata <= 32'd4;
		#10 wregn <= 5'd5;  wdata <= 32'd5;
		#10 wregn <= 5'd6;  wdata <= 32'd6;
		#10 wregn <= 5'd7;  wdata <= 32'd7;
		#10 wregn <= 5'd8;  wdata <= 32'd8;
		#10 wregn <= 5'd9;  wdata <= 32'd9;
		#10 wregn <= 5'd10; wdata <= 32'd10;
		#10 wregn <= 5'd11; wdata <= 32'd11;
		#10 wregn <= 5'd12; wdata <= 32'd12;
		#10 wregn <= 5'd13; wdata <= 32'd13;
		#10 wregn <= 5'd14; wdata <= 32'd14;
		#10 wregn <= 5'd15; wdata <= 32'd15;
		#10 wregn <= 5'd16; wdata <= 32'd16;
		#10 wregn <= 5'd17; wdata <= 32'd17;
		#10 wregn <= 5'd18; wdata <= 32'd18;
		#10 wregn <= 5'd19; wdata <= 32'd19;
		#10 wregn <= 5'd20; wdata <= 32'd20;
		#10 wregn <= 5'd21; wdata <= 32'd21;
		#10 wregn <= 5'd22; wdata <= 32'd22;
		#10 wregn <= 5'd23; wdata <= 32'd23;
		#10 wregn <= 5'd24; wdata <= 32'd24;
		#10 wregn <= 5'd25; wdata <= 32'd25;
		#10 wregn <= 5'd26; wdata <= 32'd26;
		#10 wregn <= 5'd27; wdata <= 32'd27;
		#10 wregn <= 5'd28; wdata <= 32'd28;
		#10 wregn <= 5'd29; wdata <= 32'd29;
		#10 wregn <= 5'd30; wdata <= 32'd30;
		#10 wregn <= 5'd31; wdata <= 32'd31;

		#10 wen <= 0; reg1n <= 5'd20; reg2n <= 5'd10;

		#10 $finish;
	end

endmodule
