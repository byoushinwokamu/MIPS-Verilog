module mux2 (out, in, sel);
	output out;
	input [1:0] in;
	input sel;
	assign out = sel ? in[1] : in[0];

endmodule

module mux4 (output out, input [3:0] in, [1:0] sel);
	assign out = sel[1] ? (sel[0] ? in[3] : in[2]) : (sel[0] ? in[1] : in[0]);

endmodule

module mux32x32 (
    output reg [31:0] out,
    input      [31:0] in0,  input [31:0] in1,
    input      [31:0] in2,  input [31:0] in3,
    input      [31:0] in4,  input [31:0] in5,
    input      [31:0] in6,  input [31:0] in7,
    input      [31:0] in8,  input [31:0] in9,
    input      [31:0] in10, input [31:0] in11,
    input      [31:0] in12, input [31:0] in13,
    input      [31:0] in14, input [31:0] in15,
    input      [31:0] in16, input [31:0] in17,
    input      [31:0] in18, input [31:0] in19,
    input      [31:0] in20, input [31:0] in21,
    input      [31:0] in22, input [31:0] in23,
    input      [31:0] in24, input [31:0] in25,
    input      [31:0] in26, input [31:0] in27,
    input      [31:0] in28, input [31:0] in29,
    input      [31:0] in30, input [31:0] in31,
    input      [4:0]  sel
);

	always @(*) begin
		case (sel)
			5'd0:  out = in0;
			5'd1:  out = in1;
			5'd2:  out = in2;
			5'd3:  out = in3;
			5'd4:  out = in4;
			5'd5:  out = in5;
			5'd6:  out = in6;
			5'd7:  out = in7;
			5'd8:  out = in8;
			5'd9:  out = in9;
			5'd10: out = in10;
			5'd11: out = in11;
			5'd12: out = in12;
			5'd13: out = in13;
			5'd14: out = in14;
			5'd15: out = in15;
			5'd16: out = in16;
			5'd17: out = in17;
			5'd18: out = in18;
			5'd19: out = in19;
			5'd20: out = in20;
			5'd21: out = in21;
			5'd22: out = in22;
			5'd23: out = in23;
			5'd24: out = in24;
			5'd25: out = in25;
			5'd26: out = in26;
			5'd27: out = in27;
			5'd28: out = in28;
			5'd29: out = in29;
			5'd30: out = in30;
			5'd31: out = in31;
		endcase
	end

endmodule
