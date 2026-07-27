`timescale 1ns/1ps

module tb_request_controller;

    logic clk, rst_n;
    logic start, cancel;
    logic busy, done;

    request_controller dut (
        .clk   (clk),
        .rst_n (rst_n),
        .start (start),
        .cancel(cancel),
        .busy  (busy),
        .done  (done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Helper tasks
    task tick; @(negedge clk); endtask

    task check(input string name, input logic actual, input logic expected);
        if (actual === expected)
            $display("[PASS] %s (expected=%0b, got=%0b)", name, expected, actual);
        else
            $display("[FAIL] %s (expected=%0b, got=%0b)", name, expected, actual);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_request_controller);
        rst_n = 0;
        start = 0;
        cancel = 0;
        repeat (2) tick();
        rst_n = 1;
        tick();

        $display("=== Test 1: Normal start -> busy -> done -> idle ===");

        // Apply start
        start = 1; tick(); start = 0;
        check("T1a: busy asserted after start", busy, 1'b1);
        check("T1b: done deasserted", done, 1'b0);

        // Wait for processing to complete (PROCESS_CYCLES = 3 cycles)
        repeat (3) tick();
        // After 3 cycles, the FSM should be in DONE state (one cycle)
        check("T1c: done asserted after processing", done, 1'b1);
        check("T1d: busy deasserted in DONE", busy, 1'b0);

        // Next cycle returns to IDLE
        tick();
        check("T1e: done deasserted in IDLE", done, 1'b0);
        check("T1f: busy deasserted in IDLE", busy, 1'b0);

        $display("=== Test 2: start -> busy -> cancel -> idle (abort) ===");

        start = 1; tick(); start = 0;
        check("T2a: busy asserted", busy, 1'b1);

        // Assert cancel before processing completes
        cancel = 1; tick(); cancel = 0;
        check("T2b: busy deasserted immediately on cancel", busy, 1'b0);
        check("T2c: done not asserted on abort", done, 1'b0);
        // Should be back in IDLE
        tick();
        check("T2d: still idle, no done", done, 1'b0);

        $display("All tests passed.");
        $finish;
    end

endmodule