module DataMemory (dout, din, addr, clk, wen, ren, reset);
	output reg [31:0] dout;
	input [31:0] din;
	input [9:0] addr;
	input clk, wen, ren, reset;
	
	// 1024 × 4byte RAM
	reg [31:0] mem [1023:0];
	integer i;

	always @(*) begin
		if (reset)
			for (i = 0; i < 1024; i = i+1) mem[i] <= 32'b0;
		else begin
			if (ren) dout <= mem[addr]; 
		end
	end

	always @(posedge clk)
		if (wen) mem[addr] <= din;

endmodule

module tb_DataMemory;

  reg [31:0] din;
  reg [9:0] addr;
  reg clk, wen, ren, reset;
  wire [31:0] dout;

  DataMemory dut (
    .dout(dout), .din(din), .addr(addr), .clk(clk),
    .wen(wen), .ren(ren), .reset(reset)
  );

  task tick;
    begin
      #1 clk = 1;
      #1 clk = 0;
    end
  endtask

  task test_write_read;
    input [9:0] a;
    input [31:0] d;
    input [8*20:1] label;
    begin
      $display("[%s] Writing %h to address %0d", label, d, a);
      addr = a;
      din = d;
      wen = 1;
      ren = 0;
      tick();
      wen = 0;

      ren = 1;
      tick();
      ren = 0;
      $display("    dout = %h (expected %h) %s", dout, d, (dout == d) ? "OK" : "MISMATCH");
    end
  endtask

  task test_reset;
    input [9:0] a;
    input [8*20:1] label;
    begin
      $display("[%s] Reset check at address %0d", label, a);
      reset = 1;
      tick();
      reset = 0;

      addr = a;
      ren = 1;
      tick();
      ren = 0;
      $display("    dout = %h (expected 00000000) %s", dout, (dout == 32'h00000000) ? "OK" : "MISMATCH");
    end
  endtask

  initial begin
    clk = 0;
    reset = 0;
    wen = 0;
    ren = 0;
    addr = 0;
    din = 0;

    // Write and read test
    test_write_read(10'd10, 32'hABCD1234, "Write/Read Addr 10");
    test_write_read(10'd512, 32'hDEADBEEF, "Write/Read Addr 512");

    // Reset test (check addr 10 gets cleared)
    test_reset(10'd10, "Reset Addr 10");

    $display("DataMemory tests completed.");
    $finish;
  end
endmodule