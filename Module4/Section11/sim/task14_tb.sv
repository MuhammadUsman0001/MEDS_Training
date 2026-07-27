`timescale 1ns/1ps

module tb_custom_counter;

    logic       clk;
    logic       rst;
    logic [2:0] q;

    // Device under test
    custom_counter dut (.clk(clk), .rst(rst), .q(q));

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Expected sequence
    localparam int NSTATES = 5;
    logic [2:0] expected_seq [0:NSTATES-1] = '{3'd0, 3'd1, 3'd3, 3'd4, 3'd7};

    int idx;
    int cycle_count;
    int errors;

    initial begin
        errors      = 0;
        cycle_count = 0;

        // Apply asynchronous reset
        rst = 1;
        idx = 0;
        @(negedge clk);
        @(negedge clk);
        rst = 0;

        // After reset, counter must be in state 0
        if (q !== expected_seq[0]) begin
            $error("After reset, q=%0d but expected state 0", q);
            errors++;
        end

        // Run for at least 3 full cycles (3 * 5 = 15 transitions)
        for (int i = 0; i < NSTATES * 3; i++) begin
            @(posedge clk);
            #1; // allow NBA update to settle

            idx = (idx + 1) % NSTATES;

            // Check we always land on a valid sequence state
            if (q !== expected_seq[idx]) begin
                $error("Mismatch at transition %0d: got q=%0d, expected q=%0d",
                        i, q, expected_seq[idx]);
                errors++;
            end

            // Explicitly confirm we never land on an unused state
            if (q == 3'd2 || q == 3'd5 || q == 3'd6) begin
                $error("Counter entered UNUSED state %0d - test FAILED", q);
                errors++;
            end

            if (idx == 0)
                cycle_count++;
        end

        if (errors == 0)
            $display("PASS: sequence 0->1->3->4->7 verified correctly for %0d full cycles, no unused states entered.", cycle_count);
        else
            $display("FAIL: %0d error(s) detected.", errors);

        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_custom_counter);
    end

    // Trace print
    always @(posedge clk) begin
        #1;
        $display("t=%0t  q=%b (%0d)", $time, q, q);
    end

endmodule
