module tb_mod10_divider;
    logic clk;
    logic rst_n;
    logic pulse;

    mod10_divider dut (.clk(clk), .rst_n(rst_n), .pulse(pulse));

    always #5 clk = ~clk;

    initial begin
        integer cycle_cnt;
        integer pulse_cnt;

        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Reset and release
        clk   = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;

        // Initialize counters
        cycle_cnt = 0;
        pulse_cnt = 0;

        // Wait for first pulse (ignore initial partial)
        @(posedge pulse);
        #1;

        // Count cycles between rising edges of pulse
        while (pulse_cnt < 5) begin
            @(posedge clk);
            cycle_cnt++;
            if (pulse) begin
                if (pulse_cnt > 0) begin
                    if (cycle_cnt !== 10)
                        $display("[FAIL] Period: expected 10, got %0d", cycle_cnt);
                    else
                        $display("[PASS] Period: 10 cycles");
                end
                cycle_cnt = 0;
                pulse_cnt++;
            end
        end

        $display("Tests Completed.");
        $stop;
    end
endmodule