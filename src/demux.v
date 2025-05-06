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
