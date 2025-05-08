module Add_tb;
    reg [31:0] sr, tg;
    reg cin;
    wire [31:0] res;
    wire CF, OF;

    Add inst (
        .res(res),
        .CF(CF),
        .OF(OF),
        .sr(sr),
        .tg(tg),
        .cin(cin)
    );

    task test;
        input [31:0] a, b;
        input c;
        begin
            sr = a;
            tg = b;
            cin = c;
            #1;
            $display("sr = 0x%08X, tg = 0x%08X, cin = %b", sr, tg, cin);
            $display(" → res = 0x%08X, CF = %b, OF = %b", res, CF, OF);
            $display("--------------------------------------------");
        end
    endtask

    initial begin
        $display("=== Add Module Test ===");

        // 기본 덧셈
        test(32'h00000001, 32'h00000001, 1'b0);  // 1 + 1
        test(32'h0000FFFF, 32'h00000001, 1'b0);  // 캐리 발생?

        // carry 발생
        test(32'hFFFFFFFF, 32'h00000001, 1'b0);  // CF=1, OF=0

        // overflow 발생 (양수 + 양수 = 음수)
        test(32'h7FFFFFFF, 32'h00000001, 1'b0);  // OF=1, CF=X

        // overflow 발생 (음수 + 음수 = 양수)
        test(32'h80000000, 32'h80000000, 1'b0);  // OF=1, CF=X

        // cin 테스트
        test(32'h00000001, 32'h00000001, 1'b1);  // 1+1+1 = 3

        $display("=== Test Done ===");
        #10 $finish;
    end

endmodule
