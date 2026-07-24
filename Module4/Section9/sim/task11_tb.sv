module tb_reset_synchronizer;

    logic clk;
    logic rst_n_async;
    logic rst_n_sync;

    reset_synchronizer dut (
        .clk         (clk),
        .rst_n_async (rst_n_async),
        .rst_n_sync  (rst_n_sync)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        clk = 0;
        rst_n_async = 1;
        #10;

        // Assert reset – immediate low
        rst_n_async = 0;
        #1;
        if (rst_n_sync !== 0) $display("[FAIL] Assertion");
        else $display("[PASS] Assertion");

        // Hold reset for a few clocks
        repeat (3) @(posedge clk);
        #1;
        if (rst_n_sync !== 0) $display("[FAIL] Hold");
        else $display("[PASS] Hold");

        // Deassert at random time (between edges) – expect 2-cycle delay
        rst_n_async = 1;
        #1;
        if (rst_n_sync !== 0) $display("[FAIL] Deassert immediate");
        else $display("[PASS] Deassert immediate");

        @(posedge clk);
        #1;
        if (rst_n_sync !== 0) $display("[FAIL] Deassert 1st edge");
        else $display("[PASS] Deassert 1st edge");

        @(posedge clk);
        #1;
        if (rst_n_sync !== 1) $display("[FAIL] Deassert 2nd edge");
        else $display("[PASS] Deassert 2nd edge – clean sync");

        // Deassert exactly on clock edge – expect 1-cycle delay
        rst_n_async = 0;
        #1;
        @(posedge clk);
        rst_n_async = 1;                 // deassert right at the edge

        #1;
        if (rst_n_sync !== 0) $display("[FAIL] Edge deassert immediate");
        else $display("[PASS] Edge deassert immediate");

        @(posedge clk);
        #1;
        if (rst_n_sync !== 1) $display("[FAIL] Edge deassert 1st edge");
        else $display("[PASS] Edge deassert 1st edge – clean sync");

        // Re-assert to confirm immediate low
        @(posedge clk);
        rst_n_async = 0;
        #1;
        if (rst_n_sync !== 0) $display("[FAIL] Re-assert");
        else $display("[PASS] Re-assert");

        $display("Tests completed");
        $stop;
    end

endmodule