module cache_tb;
	// Parameter definitions 
    localparam int ADDR_WIDTH      = 16;
    localparam int DATA_WIDTH      = 32;
    localparam int WORDS_PER_BLOCK = 4;
    localparam int NUM_BLOCKS      = 16;
  
    logic                    clk, rst;
    logic [ADDR_WIDTH-1:0]   address;
    logic [DATA_WIDTH-1:0]   data_in, data_out;
    logic                    req_valid, req_type;
    logic                    hit, miss, done;

    cache dut (
        .clk       (clk),
        .rst       (rst),
        .address   (address),
        .data_in   (data_in),
        .req_valid (req_valid),
        .req_type  (req_type),
        .data_out  (data_out),
        .done      (done),
        .hit       (hit),
        .miss      (miss)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    int pass_cnt = 0;
    int fail_cnt = 0;

    task tick;
        @(posedge clk);
    endtask

    task write_cache(input logic [ADDR_WIDTH-1:0] addr,
                     input logic [DATA_WIDTH-1:0] data);
        req_type  = 1'b1;
        address   = addr;
        data_in   = data;
        req_valid = 1'b1;
        tick();
        req_valid = 1'b0;
        @(negedge done);
        #1;
    endtask

    task read_cache(input logic [ADDR_WIDTH-1:0] addr,
                    output logic [DATA_WIDTH-1:0] read_data,
                    output logic hit_flag,
                    output logic miss_flag);
        req_type  = 1'b0;
        address   = addr;
        req_valid = 1'b1;
        tick();
        req_valid = 1'b0;
        @(negedge done);
        #1;
        read_data = data_out;
        hit_flag  = hit;
        miss_flag = miss;
    endtask

    task check_hit(input logic [ADDR_WIDTH-1:0] addr,
                   input logic [DATA_WIDTH-1:0] expected,
                   input string test_name);
        logic [DATA_WIDTH-1:0] rd_data;
        logic h, m;
        read_cache(addr, rd_data, h, m);
        if (h && (rd_data === expected)) begin
            $display("[PASS] %s: data=0x%0h", test_name, rd_data);
            pass_cnt++;
        end else begin
            $display("[FAIL] %s: expected 0x%0h, got hit=%0b data=0x%0h",
                     test_name, expected, h, rd_data);
            fail_cnt++;
        end
    endtask

    task check_miss(input logic [ADDR_WIDTH-1:0] addr,
                    input string test_name);
        logic [DATA_WIDTH-1:0] rd_data;
        logic h, m;
        read_cache(addr, rd_data, h, m);
        if (m) begin
            $display("[PASS] %s: miss", test_name);
            pass_cnt++;
        end else begin
            $display("[FAIL] %s: expected miss, got hit", test_name);
            fail_cnt++;
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, cache_tb);

        rst = 1'b1;
        req_valid = 1'b0;
        req_type  = 1'b0;
        address   = '0;
        data_in   = '0;
        repeat (2) tick();
        rst = 1'b0;
        tick();

        $display("\n=== Cache Testbench ===\n");

        // Test 1: Write to empty line, read back → hit
        $display("--- Test 1: Write-then-read (hit) ---");
        write_cache(16'h0001, 32'hA5A5A5A5);
        check_hit(16'h0001, 32'hA5A5A5A5, "Write-then-read");

        // Test 2: Read an unwritten line (different index) → miss
        // Address 0x0010 has index=4 (since index bits [5:2]=0x04) and is unwritten.
        $display("--- Test 2: Read unwritten line (miss) ---");
        check_miss(16'h0010, "Read unwritten line (diff index)");

        // Test 3: Same index, different tags → eviction
        // 0x0001 (index=0, tag=0) and 0x0101 (index=0, tag=4)
        $display("--- Test 3: Same index, different tags ---");
        write_cache(16'h0001, 32'hDEADBEEF);   // index=0, tag=0
        write_cache(16'h0101, 32'hCAFEF00D);   // index=0, tag=4 (evicts first)
        check_hit(16'h0101, 32'hCAFEF00D, "Same index - second write");
        check_miss(16'h0001, "Same index - first evicted");

        // Test 4: Multiple writes to different indices → all hit
        $display("--- Test 4: Multiple writes, different indices ---");
        for (int i = 0; i < 4; i++) begin
            logic [ADDR_WIDTH-1:0] addr;
            // shift i by 4 to place it in index bits [5:2]
            addr = (i << 4) | 16'h0001;
            write_cache(addr, 32'(i * 16 + 16'h1122));
            check_hit(addr, 32'(i * 16 + 16'h1122), $sformatf("idx_%0d", i));
        end

        $display("\n==========================================");
        $display("Summary: %0d passed, %0d failed", pass_cnt, fail_cnt);
        if (fail_cnt == 0)
            $display("RESULT: ALL TESTS PASSED");
        else
            $display("RESULT: SOME TESTS FAILED");
        $display("==========================================");

        $finish;
    end

endmodule