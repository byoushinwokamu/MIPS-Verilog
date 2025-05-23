module demux2x9 (out, in, en, sel);
	output reg [1:0] out;
	input in, en;
	input sel;

	always @(*) begin
		out = 2'b00;
		case (sel)
			1'b0: out[0] = in & en;
			1'b1: out[1] = in & en;
		endcase
	end

endmodule

module demux4 (out, in, en, sel);
	output reg [3:0] out;
	input in, en;
	input [1:0] sel;

	always @(*) begin
		out = 4'b0000;
		case (sel)
			2'b00: out[0] = in & en;
			2'b01: out[1] = in & en;
			2'b10: out[2] = in & en;
			2'b11: out[3] = in & en;
		endcase
	end

endmodule

module demux8 (out, in, en, sel);
	output reg [7:0] out;
	input in, en;
	input [2:0] sel;

	always @(*) begin
		out = 8'b00000000;
		case (sel)
			3'b000: out[0] = in & en;
			3'b001: out[1] = in & en;
			3'b010: out[2] = in & en;
			3'b011: out[3] = in & en;
			3'b100: out[4] = in & en;
			3'b101: out[5] = in & en;
			3'b110: out[6] = in & en;
			3'b111: out[7] = in & en;
		endcase
	end

endmodule

module demux48_tb;
	reg [2:0] sel;
	reg in, en;
	wire [3:0] out4;
	wire [7:0] out8;

	demux4 d4(out4, in, en, sel[1:0]);
	demux8 d8(out8, in, en, sel[2:0]);

	initial begin
		sel <= 3'b0;
		in <= 1'b1;
		en <= 1'b0;

		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 en <= 1'b1; sel <= 3'b0;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;
		#10 sel <= sel + 1;

		#10 $finish;
	end

endmodule