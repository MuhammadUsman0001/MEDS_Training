`timescale 1ns/1ps

module tb_fifo_controller;

    localparam int ADDR_WIDTH = 3;   // depth = 8 (default parameters)
    localparam int DATA_WIDTH = 8;
    localparam int DEPTH      = 1 << ADDR_WIDTH;

    logic                   clk;
    logic                   rst_n;
    logic                   wr_en;
    logic [DATA_WIDTH-1:0]  wr_data;
    logic                   wr_ready;
    logic                   rd_en;
    logic [DATA_WIDTH-1:0]  rd_data;
    logic                   rd_valid;
    logic                   full;
    logic                   empty;
    logic [ADDR_WIDTH:0]    count;
    logic                   almost_full;
    logic                   almost_empty;

    int pass_count = 0;
    int fail_count = 0;

    fifo_controller #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .wr_en        (wr_en),
        .wr_data      (wr_data),
        .wr_ready     (wr_ready),
        .rd_en        (rd_en),
        .rd_data      (rd_data),
        .rd_valid     (rd_valid),
        .full         (full),
        .empty        (empty),
        .count        (count),
        .almost_full  (almost_full),
        .almost_empty (almost_empty)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveforms/fifo_waveform.vcd");
        $dumpvars(0, tb_fifo_controller);
    end

    // Helper tasks
    task automatic tick;
        @(negedge clk);
    endtask

    // Drive a write for one cycle (caller checks wr_ready beforehand if needed)
    task automatic do_write(input logic [DATA_WIDTH-1:0] d);
        wr_en   = 1'b1;
        wr_data = d;
        tick();
        wr_en   = 1'b0;
    endtask

    // Drive a read for one cycle
    task automatic do_read(output logic [DATA_WIDTH-1:0] d, output logic v);
        d = rd_data;   // show-ahead: sample head BEFORE popping
        v = rd_valid;
        rd_en = 1'b1;
        tick();
        rd_en = 1'b0;
    endtask

    task automatic check(input string name, input logic actual, input logic expected);
        if (actual === expected) begin
            $display("[PASS] %s (expected=%0b, got=%0b)", name, expected, actual);
            pass_count++;
        end else begin
            $display("[FAIL] %s (expected=%0b, got=%0b)", name, expected, actual);
            fail_count++;
        end
    endtask

    task automatic check_val(input string name, input logic [31:0] actual, input logic [31:0] expected);
        if (actual === expected) begin
            $display("[PASS] %s (expected=%0d, got=%0d)", name, expected, actual);
            pass_count++;
        end else begin
            $display("[FAIL] %s (expected=%0d, got=%0d)", name, expected, actual);
            fail_count++;
        end
    endtask

    // Test sequence
    logic [DATA_WIDTH-1:0] rdata_tmp;
    logic                  rvalid_tmp;
    int i;

    initial begin
        wr_en   = 1'b0;
        rd_en   = 1'b0;
        wr_data = '0;
        rst_n   = 1'b0;
        repeat (2) tick();
        rst_n = 1'b1;
        tick();

        $display("=== Synchronous FIFO Controller Self-Checking Testbench ===");

        // 1) Reset behaviour
        check("T1a: empty asserted after reset", empty, 1'b1);
        check("T1b: full deasserted after reset", full, 1'b0);
        check_val("T1c: count is 0 after reset", count, 0);
        check("T1d: wr_ready asserted after reset", wr_ready, 1'b1);
        check("T1e: rd_valid deasserted after reset", rd_valid, 1'b0);

        // 2) Normal write/read, FIFO ordering
        do_write(8'hA5);
        check("T2a: empty clears after one write", empty, 1'b0);
        check_val("T2b: count is 1 after one write", count, 1);
        check("T2c: rd_valid asserted with one item queued", rd_valid, 1'b1);
        check_val("T2d: head of queue is the written value", rd_data, 8'hA5);

        do_read(rdata_tmp, rvalid_tmp);
        check_val("T2e: read returned the written value", rdata_tmp, 8'hA5);
        check("T2f: empty reasserted after draining the only item", empty, 1'b1);
        check_val("T2g: count is 0 after draining", count, 0);

        // Push 3 items, confirm they pop back in the SAME order (FIFO, not LIFO)
        do_write(8'h11);
        do_write(8'h22);
        do_write(8'h33);
        check_val("T2h: count is 3 after three writes", count, 3);
        do_read(rdata_tmp, rvalid_tmp); check_val("T2i: first-out matches first-in (0x11)", rdata_tmp, 8'h11);
        do_read(rdata_tmp, rvalid_tmp); check_val("T2j: second-out matches second-in (0x22)", rdata_tmp, 8'h22);
        do_read(rdata_tmp, rvalid_tmp); check_val("T2k: third-out matches third-in (0x33)", rdata_tmp, 8'h33);
        check("T2l: empty again after draining all three", empty, 1'b1);

        // 3) Fill to full, check full/wr_ready, then test overflow
        for (i = 0; i < DEPTH; i++) begin
            do_write(8'(i + 8'h50)); // 0x50, 0x51, ... 0x57
        end
        check("T3a: full asserted after DEPTH writes", full, 1'b1);
        check("T3b: wr_ready deasserted when full", wr_ready, 1'b0);
        check_val("T3c: count equals DEPTH when full", count, DEPTH);

        // Overflow: attempt one more write while full. wr_ready is low so
        // the DUT must ignore this write entirely -- no data corruption.
        do_write(8'hFF);
        check("T3d: full still asserted after blocked overflow write", full, 1'b1);
        check_val("T3e: count unchanged after blocked overflow write", count, DEPTH);

        // Drain everything and confirm the ORIGINAL data survived intact
        // (i.e. the overflow write never got written into the array).
        begin : drain_check
            automatic bit all_ok = 1'b1;
            for (i = 0; i < DEPTH; i++) begin
                do_read(rdata_tmp, rvalid_tmp);
                if (rdata_tmp !== 8'(i + 8'h50)) all_ok = 1'b0;
            end
            check("T3f: all DEPTH original values read back uncorrupted, in order", all_ok, 1'b1);
        end
        check("T3g: empty asserted after draining all items", empty, 1'b1);

        // 4) Underflow: read attempted while empty
        check("T4a: rd_valid deasserted on empty FIFO", rd_valid, 1'b0);
        do_read(rdata_tmp, rvalid_tmp); // rd_en asserted while empty
        check("T4b: empty still asserted after blocked underflow read", empty, 1'b1);
        check_val("T4c: count still 0 after blocked underflow read", count, 0);
        // Confirm the FIFO still works normally afterward (state wasn't corrupted)
        do_write(8'h7E);
        do_read(rdata_tmp, rvalid_tmp);
        check_val("T4d: FIFO still functions correctly after underflow attempt", rdata_tmp, 8'h7E);

        // 5) Simultaneous read + write
        do_write(8'hAA);
        do_write(8'hBB);
        check_val("T5a: count is 2 before simultaneous op", count, 2);

        // Issue a write and a read in the SAME cycle
        wr_en   = 1'b1; wr_data = 8'hCC;
        rd_en   = 1'b1;
        rdata_tmp = rd_data; // sample head (0xAA) before the pop takes effect
        tick();
        wr_en = 1'b0; rd_en = 1'b0;

        check_val("T5b: simultaneous op popped the correct head (0xAA)", rdata_tmp, 8'hAA);
        check_val("T5c: count unchanged (one in, one out) after simultaneous op", count, 2);
        do_read(rdata_tmp, rvalid_tmp);
        check_val("T5d: next item is 0xBB (order preserved)", rdata_tmp, 8'hBB);
        do_read(rdata_tmp, rvalid_tmp);
        check_val("T5e: last item is the newly written 0xCC", rdata_tmp, 8'hCC);
        check("T5f: empty after draining post-simultaneous-op items", empty, 1'b1);

        // 6) Task 18: almost_full / almost_empty
        for (i = 0; i < DEPTH - 1; i++) begin
            do_write(8'(i));
        end
        check_val("T6a: count is DEPTH-1", count, DEPTH - 1);
        check("T6b: almost_full asserted at DEPTH-1 items", almost_full, 1'b1);
        check("T6c: full NOT asserted at DEPTH-1 items", full, 1'b0);

        // One more write reaches true full; almost_full's definition (count==DEPTH-1)
        // means it should now be LOW again (distinct one-away warning, not sticky).
        do_write(8'hD0);
        check("T6d: full asserted after topping up to DEPTH", full, 1'b1);
        check("T6e: almost_full deasserted once truly full", almost_full, 1'b0);

        // Drain down to exactly 1 item remaining
        for (i = 0; i < DEPTH - 1; i++) begin
            do_read(rdata_tmp, rvalid_tmp);
        end
        check_val("T6f: count is 1", count, 1);
        check("T6g: almost_empty asserted at 1 item", almost_empty, 1'b1);
        check("T6h: empty NOT asserted at 1 item", empty, 1'b0);

        // Summary
        $display("=================================================");
        $display("TOTAL: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count == 0)
            $display("RESULT: ALL TESTS PASSED");
        else
            $display("RESULT: SOME TESTS FAILED");
        $display("=================================================");

        $finish;
    end

endmodule
