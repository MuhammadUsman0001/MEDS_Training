module tb;
    logic       en;
    logic [2:0] sel;
    logic [7:0] y;
    logic [7:0] expected;

    decoder3to8 dut (.*);

    task automatic check;
        if (y === expected)
          	$display("[PASS] en=%0b sel=%0b (%0d) : y=%0b", en, sel, sel, y);
        else
          	$display("[FAIL] en=%0b sel=%0b (%0d) : y=%0b (expected=%0b)", 
                     en, sel, sel, y, expected);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Test all 8 sel values with en = 1
        for (int i = 0; i < 8; i++) begin
            en  = 1'b1;
            sel = i[2:0];
            #10;
            expected = 8'b1 << sel;
            check();
        end

        // Test all 8 sel values with en = 0
        en = 1'b0;
        for (int i = 0; i < 8; i++) begin
            sel = i[2:0];
            #10;
            expected = 8'b0000_0000;
            check();
        end

        #10;
        $finish;
    end
endmodule