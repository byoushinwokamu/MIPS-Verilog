module DataMemory (dout, din, addr, clk, wen, ren, reset);
	output reg [31:0] dout;
	input [31:0] din;
	input [9:0] addr;
	input clk, wen, ren, reset;
	
	// 1024 × 4byte RAM
	reg [31:0] mem [1023:0];
	integer i;

	// if fucked up, always @(*)
	always @(posedge clk or posedge reset) begin
		if (reset)
			for (i = 0; i < 1024; i = i+1) mem[i] <= 32'b0;
		else begin
			if (wen) mem[addr] <= din;
			if (ren) dout <= mem[addr]; 
		end
	end

endmodule

module DataMemory_tb;
    reg clk, wen, ren, reset;
    reg [9:0] addr;
    reg [31:0] din;
    wire [31:0] dout;

    DataMemory inst (
        .dout(dout),
        .din(din),
        .addr(addr),
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0; wen = 0; ren = 0; reset = 0;
        addr = 0; din = 0;
        $display("=== DataMemory Test Start ===");

        // Reset
        #5 reset = 1;
        #10 reset = 0;

        // Write
        #10 wen = 1; ren = 0; addr = 10'd15; din = 32'hCAFEBABE;
        #10 wen = 0;

        // Read
        #10 ren = 1;
        #10 ren = 0;
        #1  $display("Read from addr %0d = 0x%08X (expected 0xCAFEBABE)", addr, dout);

        // Another write & read
        #10 wen = 1; addr = 10'd100; din = 32'h12345678;
        #10 wen = 0;

        #10 ren = 1; addr = 10'd100;
        #10 ren = 0;
        #1  $display("Read from addr %0d = 0x%08X (expected 0x12345678)", addr, dout);

        $display("=== DataMemory Test Done ===");
        #10 $finish;
    end
endmodule