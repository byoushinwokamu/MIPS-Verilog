module reg32 (readdata, writedata, clk, wen, reset);
	output [31:0] readdata;
	input [31:0] writedata;
	input clk, wen, reset;

	dff dffs [31:0] (readdata, writedata, clk, wen, reset);

endmodule

module reg32_ll (readdata, writedata, clk, wen, reset);
	output reg [31:0] readdata;
	input [31:0] writedata;
	input clk, wen, reset;

	always @(*) begin
		if (reset) readdata <= 32'b0;
		else if (~clk && wen) readdata <= writedata;
	end

endmodule

module reg32_tb;
	wire [31:0] q;
	reg [31:0] d;
	reg clk, wen, rst;
	reg32 inst(q, d, clk, wen, rst);

	always #5 clk = ~clk;

	initial begin
		d <= 32'd0; clk <= 0; wen <= 0;
		rst <= 1; 

		#10 rst <= 0;
		d <= 32'h1234abcd; wen <= 1;

		#10
		d <= 32'hdfdf7878;

		#10
		d <= 32'hffffffff; wen <= 0;

		#10
		wen <= 1;

		#10 $finish;
	end
	
endmodule

module reg32_ll_tb;
    reg [31:0] writedata;
    reg clk, wen, reset;
    wire [31:0] readdata;

    reg32_ll dut (
        .readdata(readdata),
        .writedata(writedata),
        .clk(clk),
        .wen(wen),
        .reset(reset)
    );

    task show(input string tag);
        begin
            $display("[%s] clk=%b wen=%b reset=%b → readdata=0x%08X", 
                tag, clk, wen, reset, readdata);
        end
    endtask

    initial begin
        $display("=== reg32_ll Test ===");

        // 초기화
        clk = 1; wen = 0; reset = 1; writedata = 32'hDEAD_BEEF;
        #1 show("reset asserted");
        reset = 0; #1;

        // clk=0, wen=1 → write 동작
        clk = 0; wen = 1; writedata = 32'h12345678; #1;
        show("write on clk=0");

        // clk=1 → write 안됨
        clk = 1; #1;
        writedata = 32'h99999999; #1;
        show("no write on clk=1");

        // clk=0, wen=1 → write 다시
        clk = 0; writedata = 32'hABCDEF01; #1;
        show("second write on clk=0");

        // clk=0, wen=0 → 유지
        wen = 0; writedata = 32'hFFFFFFFF; #1;
        show("write disabled");

        $display("=== Done ===");
        #5 $finish;
    end
endmodule
