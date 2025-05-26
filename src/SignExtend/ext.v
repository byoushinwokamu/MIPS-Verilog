module ImmediateExtender (
	output [31:0] out,
	input [15:0] in,
	input ZeroExtend
);
	assign out[15:0] = in;
	assign out[31:16] = ZeroExtend ? 16'b0 : {16{in[15]}};

endmodule

module tb_ImmediateExtender;

  reg [15:0] in;
  reg ZeroExtend;
  wire [31:0] out;

  ImmediateExtender dut (
    .out(out), .in(in), .ZeroExtend(ZeroExtend)
  );

  task test_extend;
    input [15:0] val;
    input zext;
    input [31:0] expected;
    input [8*20:1] label;
    begin
      in = val;
      ZeroExtend = zext;
      #1;
      $display("[%s]", label);
      $display("    in = %h, ZeroExtend = %b", val, zext);
      $display("    out = %h (expected %h) %s", out, expected, (out == expected) ? "OK" : "MISMATCH");
    end
  endtask

  initial begin
    // Zero extend positive
    test_extend(16'h1234, 1'b1, 32'h00001234, "ZeroExtend pos");

    // Zero extend negative (MSB=1 but zero extended)
    test_extend(16'hF234, 1'b1, 32'h0000F234, "ZeroExtend neg");

    // Sign extend positive
    test_extend(16'h1234, 1'b0, 32'h00001234, "SignExtend pos");

    // Sign extend negative
    test_extend(16'hF234, 1'b0, 32'hFFFFF234, "SignExtend neg");

    $display("ImmediateExtender tests completed.");
    $finish;
  end
endmodule