module SyscallDecoder (
	output Halt,
	output [31:0] Hex,
	input [31:0] v0,
	input [31:0] a0,
	input clk, en, reset
);
	wire compv0;
	assign compv0 = (v0 == 32'hA);
	assign Halt = en ? compv0 : 1'b0;

	reg32 rega0 (.readdata(Hex), .writedata(a0), .clk, .wen(en), .reset);

endmodule

module tb_SyscallDecoder;

  reg [31:0] v0, a0;
  reg clk, en, reset;
  wire Halt;
  wire [31:0] Hex;

  SyscallDecoder dut (
    .Halt(Halt), .Hex(Hex), .v0(v0), .a0(a0), .clk(clk), .en(en), .reset(reset)
  );

  task tick;
    begin
      #1 clk = 1;
      #1 clk = 0;
    end
  endtask

  task test_syscall;
    input [31:0] test_v0, test_a0;
    input expect_halt;
    input [31:0] expect_hex;
    input [8*30:1] label;
    begin
      v0 = test_v0;
      a0 = test_a0;
      en = 1;
      tick();
      en = 0;

      $display("[%s]", label);
      $display("    v0 = %h, a0 = %h", v0, a0);
      $display("    Halt = %b (expected %b) %s", Halt, expect_halt, (Halt == expect_halt) ? "OK" : "MISMATCH");
      $display("    Hex  = %h (expected %h) %s", Hex, expect_hex, (Hex == expect_hex) ? "OK" : "MISMATCH");
    end
  endtask

  initial begin
    clk = 0;
    reset = 1;
    en = 0;
    tick();
    reset = 0;

    // Basic syscall write (non-halt)
    test_syscall(32'h00000001, 32'h12345678, 0, 32'h12345678, "Write Hex, no halt");

    // Syscall halt
    test_syscall(32'h0000000A, 32'hDEADBEEF, 1, 32'hDEADBEEF, "Halt and write");

    // en = 0 should not write
    v0 = 32'h0000000A;
    a0 = 32'hFEEDFACE;
    en = 0;
    tick();
    $display("[No enable]");
    $display("    Hex = %h (expected unchanged) %s", Hex, (Hex == 32'hDEADBEEF) ? "OK" : "MISMATCH");
    $display("    Halt = %b (expected 0) %s", Halt, (Halt == 1'b0) ? "OK" : "MISMATCH");

    $display("SyscallDecoder tests completed.");
    $finish;
  end
endmodule