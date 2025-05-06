module mux32x32_tb;
  reg [31:0] in [0:31]; 
  reg [4:0] sel;
  wire [31:0] out;

  mux32x32 inst (
    .out(out),
    .in0(in[0]), .in1(in[1]), .in2(in[2]), .in3(in[3]),
    .in4(in[4]), .in5(in[5]), .in6(in[6]), .in7(in[7]),
    .in8(in[8]), .in9(in[9]), .in10(in[10]), .in11(in[11]),
    .in12(in[12]), .in13(in[13]), .in14(in[14]), .in15(in[15]),
    .in16(in[16]), .in17(in[17]), .in18(in[18]), .in19(in[19]),
    .in20(in[20]), .in21(in[21]), .in22(in[22]), .in23(in[23]),
    .in24(in[24]), .in25(in[25]), .in26(in[26]), .in27(in[27]),
    .in28(in[28]), .in29(in[29]), .in30(in[30]), .in31(in[31]),
    .sel(sel)
  );

  integer i;

  initial begin
		// Initialize value
    for (i = 0; i < 32; i = i + 1) begin
      in[i] = 32'hDEAD0000 + i;
    end

		// Test
    for (i = 0; i < 32; i = i + 1) begin
      sel = i;
      #5
      $display("sel = %2d -> out = %h (expected %h)", sel, out, in[sel]);
      if (out !== in[sel]) $display("***MISMATCH at sel = %d", sel);
    end

		$display("terminated");
    $finish;
  end
endmodule
