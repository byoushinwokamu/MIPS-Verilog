module InstMemory #(
	parameter INIT_FILE1 = "program1.hex", INIT_FILE2 = "program2.hex"
) (dout, addr, clk, reset);
	output [31:0] dout;
	input [9:0] addr;
	input clk, reset;

	wire memsel;
	wire [31:0] dout1;
	wire [31:0] dout2;
	InstMem_half #(.INIT_FILE(INIT_FILE1)) IMem1 (
		.dout(dout1), .addr(addr[8:0]), .clk, .reset
	);
	InstMem_half #(.INIT_FILE(INIT_FILE2)) IMem2 (
		.dout(dout2), .addr(addr[8:0]), .clk, .reset
	);

	// Multiplexing output
	assign dout = (addr[9] ? dout2 : dout1);

endmodule

module tb_InstMemory;

  reg [9:0] addr;
  reg clk, reset;
  wire [31:0] dout;

  // Test instance with test hex files (replace with your actual files)
  InstMemory #(
    .INIT_FILE1("prog1.hex"),
    .INIT_FILE2("prog2.hex")
  ) dut (
    .dout(dout), .addr(addr), .clk(clk), .reset(reset)
  );

  task tick;
    begin
      #1 clk = 1;
      #1 clk = 0;
    end
  endtask

  task test_read;
    input [9:0] address;
    input [31:0] expected;
    input [8*20:1] label;
    begin
      addr = address;
      tick();
      $display("[%s] addr = %h", label, address);
      $display("    dout = %h (expected %h) %s", dout, expected, (dout == expected) ? "OK" : "MISMATCH");
    end
  endtask

  initial begin
    clk = 0;
    reset = 1;
    tick();
    reset = 0;

    test_read(10'd0,    32'h20110001, "IMem1 addr 0");
    test_read(10'd1,    32'h08000c05, "IMem1 addr 1");
    test_read(10'd255,  32'h0000000c, "IMem1 addr 255");

    test_read(10'd256,  32'h16310005, "IMem2 addr 0");
    test_read(10'd300,  32'h0000000c, "IMem2 addr 44");
    test_read(10'd511,  32'h00000000, "IMem2 addr 255");

    $display("InstMemory tests completed.");
    $finish;
  end
endmodule