`timescale 1ns/1ps

module tb_div3_detector;

    logic clk, rst_n, x, y;

    div3_detector dut (
        .clk  (clk),
        .rst_n(rst_n),
        .x    (x),
        .y    (y)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Helper: drive one bit and check output
    task tick;
        @(negedge clk);
    endtask

    task send_bit(input logic in_bit, input logic expected_y);
        x = in_bit;
        tick();
        #1; // let combinational output settle
        if (y !== expected_y)
            $display("[FAIL] bit=%0b, y=%0b, expected=%0b", in_bit, y, expected_y);
        else
            $display("[PASS] bit=%0b, y=%0b", in_bit, y);
    endtask

    // Reference model: computes remainder after each bit
    function automatic int compute_remainder(int current_rem, logic in_bit);
        compute_remainder = (current_rem * 2 + in_bit) % 3;
    endfunction

    // Test a full binary sequence
    task test_sequence(input logic [7:0] bits, input int num_bits, input string name);
        int rem = 0;
        int expected;
        $display("=== Testing %s ===", name);
        for (int i = num_bits-1; i >= 0; i--) begin
            rem = compute_remainder(rem, bits[i]);
            expected = (rem == 0) ? 1'b1 : 1'b0;
            send_bit(bits[i], expected);
        end
        // After the sequence, the FSM should be in the correct remainder state.
        // The testbench doesn't check the state explicitly, but the output covers it.
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_div3_detector);

        rst_n = 0;
        x = 0;
        repeat (2) tick();
        rst_n = 1;
        tick();

        // Test known sequences
        test_sequence(8'b00000110, 3, "110 (6, divisible)");   // 6 (binary 110)
        test_sequence(8'b00000101, 3, "101 (5, not divisible)");
        test_sequence(8'b00001001, 4, "1001 (9, divisible)");
        test_sequence(8'b00000111, 3, "111 (7, not divisible)");

        $display("All tests completed.");
        $finish;
    end

endmodule