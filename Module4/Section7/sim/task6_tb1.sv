module tb_decoder2to4;
    logic       en;
    logic [1:0] sel;
    logic [3:0] y;
    logic [3:0] expected;

    decoder2to4 dut (.*);

    task automatic check;
        if (y === expected)
            $display("[PASS] en=%0b sel=%0b (%0d) : y=%0b", en, sel, sel, y);
        else
            $display("[FAIL] en=%0b sel=%0b (%0d) : y=%0b (expected=%0b)",
                     en, sel, sel, y, expected);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_decoder2to4);

        // Test all 4 sel values with en = 1
        for (int i = 0; i < 4; i++) begin
            en  = 1'b1;
            sel = i[1:0];
            #10;
            expected = 4'b1 << sel;
            check();
        end

        // Test all 4 sel values with en = 0
        en = 1'b0;
        for (int i = 0; i < 4; i++) begin
            sel = i[1:0];
            #10;
            expected = 4'b0000;
            check();
        end

        #10;
        $finish;
    end
endmodule