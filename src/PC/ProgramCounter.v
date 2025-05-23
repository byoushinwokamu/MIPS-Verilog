module ProgramCounter (
	output [31:0] progaddr,
	input [31:0] prevprog,
	input [31:0] op,
	input [31:0] jumpamt,
	input [31:0] jumpaddr,
	input [31:0] CP0_PCout,
	input IsEret, IsCOP0, HasExp, Equal, BneOrBeq, Branch, Jump, IsJR, clk, reset
);
	wire [31:0] wnextprog;
	wire [31:0] wjump;
	wire [31:0] wjadd;
	wire [31:0] wmux1;
	wire [31:0] wmux2;
	wire wand1;
	wire [31:0] wfinalpc;
	wire [31:0] wmux3;
	wire [31:0] wmux4;
	wire wmux5, wand2, wor1;

	assign wnextprog = prevprog + 32'h4;
	assign wjump = {wnextprog[31:28], op[25:0], 2'b0};
	assign wjadd = wnextprog + (jumpamt << 2);
	and (wand1, Branch, Equal ^ BneOrBeq);
	assign wmux1 = wand1 ? wjadd : wnextprog;
	assign wmux2 = ~Jump ? wmux1 : wjump;
	assign wfinalpc = IsJR ? jumpaddr : wmux2;

	and (wand2, IsEret, IsCOP0);
	or (wor1, wand2, HasExp);
	assign wmux3 = wand2 ? CP0_PCout : wfinalpc;
	assign wmux4 = ~HasExp ? wmux3 : 32'h800;
	assign wmux5 = wor1 ? ~clk : clk;

	reg32 PC (.readdata(progaddr), .writedata(wmux4), .clk(wmux5), .wen(1'b1), .reset);

endmodule

module ProgramCounter_tb;
    reg [31:0] prevprog, jumpamt, jumpaddr, CP0_PCout;
    reg [25:0] op;
    reg IsEret, IsCOP0, HasExp, Equal, BneOrBeq, Branch, Jump, IsJR, clk, reset;
    wire [31:0] progaddr;

    ProgramCounter inst (
        .progaddr, .prevprog, .op, .jumpamt, .jumpaddr, .CP0_PCout,
        .IsEret, .IsCOP0, .HasExp, .Equal, .BneOrBeq, .Branch, .Jump, .IsJR,
        .clk, .reset
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task tick;
        begin #10; end
    endtask

    task reset_all;
        begin
            prevprog = 32'h1000;
            op = 26'h0000000;
            jumpamt = 0;
            jumpaddr = 0;
            CP0_PCout = 32'hDEAD_BEEF;
            IsEret = 0; IsCOP0 = 0; HasExp = 0;
            Equal = 0; BneOrBeq = 0; Branch = 0;
            Jump = 0; IsJR = 0;
            reset = 1; tick(); reset = 0; tick();
        end
    endtask

    initial begin
        $display("=== ProgramCounter Test (Verilog2001) ===");
        reset_all();

        // 기본 동작: PC + 4
        tick();
        $display("[Normal PC+4] progaddr = 0x%08X", progaddr);

        // Branch taken: Equal ^ BneOrBeq = 1
        jumpamt = 32'd4;
        Branch = 1; Equal = 1; BneOrBeq = 0;
        tick();
        $display("[Branch taken] progaddr = 0x%08X", progaddr);

        // Jump (J-type)
        Jump = 1; Branch = 0; op = 26'h3FFFFF;
        tick();
        $display("[Jump] progaddr = 0x%08X", progaddr);

        // JR
        Jump = 0; IsJR = 1; jumpaddr = 32'hCAFEBABE;
        tick();
        $display("[Jump Register] progaddr = 0x%08X", progaddr);

        // Exception
        IsJR = 0; HasExp = 1;
        tick();
        $display("[Exception] progaddr = 0x%08X", progaddr);

        // ERET
        HasExp = 0; IsCOP0 = 1; IsEret = 1;
        tick();
        $display("[ERET] progaddr = 0x%08X", progaddr);

        $display("=== Done ===");
        #20 $finish;
    end

endmodule