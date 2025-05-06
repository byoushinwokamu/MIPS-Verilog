module OPDecoder_tb;
    reg op0, op1, op2, op3, op4, op5;
    wire MemRead, MemWrite, ALUSrc, Jump, MemtoReg;
    wire Branch, RegDst, RegWrite, BneBeq, IsJAL, ZeroExtend;

    OPDecoder inst (
        .MemRead, .MemWrite, .ALUSrc, .Jump, .MemtoReg,
        .Branch, .RegDst, .RegWrite, .BneBeq, .IsJAL, .ZeroExtend,
        .op0, .op1, .op2, .op3, .op4, .op5
    );

    task test_opcode;
        input [5:0] opcode;
        input [10:0] expected;
        begin
            {op0, op1, op2, op3, op4, op5} = opcode;

            #1; // propagation delay

            $display("opcode = %b -> MemRead  = %b (exp %b)", opcode, MemRead, expected[10]);
            $display("                   MemWrite = %b (exp %b)", MemWrite, expected[9]);
            $display("                   ALUSrc   = %b (exp %b)", ALUSrc, expected[8]);
            $display("                   Jump     = %b (exp %b)", Jump, expected[7]);
            $display("                   MemtoReg = %b (exp %b)", MemtoReg, expected[6]);
            $display("                   Branch   = %b (exp %b)", Branch, expected[5]);
            $display("                   RegDst   = %b (exp %b)", RegDst, expected[4]);
            $display("                   RegWrite = %b (exp %b)", RegWrite, expected[3]);
            $display("                   BneBeq   = %b (exp %b)", BneBeq, expected[2]);
            $display("                   IsJAL    = %b (exp %b)", IsJAL, expected[1]);
            $display("                   ZeroExt  = %b (exp %b)", ZeroExtend, expected[0]);
            $display("------------------------");
        end
    endtask

    initial begin
        $display("=== OPDecoder Test Start ===");

        // opcode 100011 (lw)
        test_opcode(6'b100011, 11'b1_0_1_0_1_0_0_1_0_0_0);  // MemRead, ALUSrc, MemtoReg, RegWrite

        // opcode 101011 (sw)
        test_opcode(6'b101011, 11'b0_1_1_0_0_0_0_0_0_0_0);  // MemWrite, ALUSrc

        // opcode 000100 (beq)
        test_opcode(6'b000100, 11'b0_0_0_0_0_1_0_0_1_0_0);  // Branch, BneBeq

        // opcode 000101 (bne)
        test_opcode(6'b000101, 11'b0_0_0_0_0_1_0_0_1_0_0);  // Branch, BneBeq

        // opcode 001000 (addi)
        test_opcode(6'b001000, 11'b0_0_1_0_0_0_0_1_0_0_0);  // ALUSrc, RegWrite

        // opcode 000011 (jal)
        test_opcode(6'b000011, 11'b0_0_0_1_0_0_0_1_0_1_0);  // Jump, RegWrite, IsJAL

        $display("=== OPDecoder Test Done ===");
        #10 $finish;
    end

endmodule
