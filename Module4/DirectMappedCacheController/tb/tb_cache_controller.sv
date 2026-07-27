`timescale 1ns/1ps

module tb_cache_controller;

    localparam int ADDR_WIDTH  = 16;
    localparam int DATA_WIDTH  = 32;
    localparam int INDEX_WIDTH = 4;
    localparam int OFFSET_WIDTH = 2; // $clog2(32/8)

    logic                  clk;
    logic                  rst_n;
    logic                  req_valid;
    logic                  req_we;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] wdata;
    logic [DATA_WIDTH-1:0] rdata;
    logic                  hit;
    logic                  ready;

    int pass_count = 0;
    int fail_count = 0;

    // DUT instantiation
    cache_controller #(
        .ADDR_WIDTH  (ADDR_WIDTH),
        .DATA_WIDTH  (DATA_WIDTH),
        .INDEX_WIDTH (INDEX_WIDTH)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .req_valid (req_valid),
        .req_we    (req_we),
        .addr      (addr),
        .wdata     (wdata),
        .rdata     (rdata),
        .hit       (hit),
        .ready     (ready)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_cache_controller);
    end

    // Helper tasks
    task automatic do_write(input logic [ADDR_WIDTH-1:0] a, input logic [DATA_WIDTH-1:0] d);
        @(negedge clk);
        req_valid = 1'b1;
        req_we    = 1'b1;
        addr      = a;
        wdata     = d;
        @(negedge clk);
        req_valid = 1'b0;
        req_we    = 1'b0;
    endtask

    task automatic do_read(input logic [ADDR_WIDTH-1:0] a,
                            output logic hit_o,
                            output logic [DATA_WIDTH-1:0] data_o);
        @(negedge clk);
        req_valid = 1'b1;
        req_we    = 1'b0;
        addr      = a;
        @(negedge clk);
        hit_o  = hit;
        data_o = rdata;
        req_valid = 1'b0;
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

    task automatic check_data(input string name, input logic [DATA_WIDTH-1:0] actual, input logic [DATA_WIDTH-1:0] expected);
        if (actual === expected) begin
            $display("[PASS] %s (expected=0x%0h, got=0x%0h)", name, expected, actual);
            pass_count++;
        end else begin
            $display("[FAIL] %s (expected=0x%0h, got=0x%0h)", name, expected, actual);
            fail_count++;
        end
    endtask

    // Test sequence
    logic                  h;
    logic [DATA_WIDTH-1:0] d;

    // Two addresses that alias to the SAME index but have DIFFERENT tags.
    // index = addr[5:2] ; tag = addr[15:6]
    localparam logic [ADDR_WIDTH-1:0] ADDR_A  = 16'h0040; // index=0, tag=1
    localparam logic [ADDR_WIDTH-1:0] ADDR_B  = 16'h0014; // index=5, tag=0 -- different index, unwritten
    localparam logic [ADDR_WIDTH-1:0] ADDR_C  = 16'h0840; // same index as A (index=0), tag=33 (different)

    initial begin
        // Reset
        rst_n     = 1'b0;
        req_valid = 1'b0;
        req_we    = 1'b0;
        addr      = '0;
        wdata     = '0;
        repeat (2) @(negedge clk);
        rst_n = 1'b1;

        $display("=== Direct-Mapped Cache Controller Self-Checking Testbench ===");

        // Test 1: Write to an empty line, then read the same address back
        do_write(ADDR_A, 32'hDEAD_BEEF);
        do_read(ADDR_A, h, d);
        check("T1a: read-after-write is a HIT", h, 1'b1);
        check_data("T1b: read-after-write data matches", d, 32'hDEAD_BEEF);

        // Test 2: Read a different address that maps to an empty line
        do_read(ADDR_B, h, d);
        check("T2: read to never-written line is a MISS", h, 1'b0);

        // Test 3: Two addresses, same index, different tags
        // ADDR_C maps to the same index as ADDR_A but has a different tag.
        do_write(ADDR_C, 32'hCAFE_F00D);
        do_read(ADDR_C, h, d);
        check("T3a: read-after-write of ADDR_C is a HIT", h, 1'b1);
        check_data("T3b: ADDR_C data matches", d, 32'hCAFE_F00D);

        // Writing ADDR_C evicted ADDR_A's line (direct-mapped, same index).
        do_read(ADDR_A, h, d);
        check("T3c: ADDR_A now MISSES after eviction by ADDR_C", h, 1'b0);

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
