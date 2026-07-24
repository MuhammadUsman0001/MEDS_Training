module stopwatch_tb;

    logic       clk, clr;
    logic [3:0] min, sec_ones, tenth;
    logic [2:0] sec_tens;
    logic       tick;

    int tick_count = 0;

    stopwatch #(.TICK_CYCLES(3)) dut (
        .clk      (clk),
        .clr      (clr),
        .min      (min),
        .sec_tens (sec_tens),
        .sec_ones (sec_ones),
        .tenth    (tenth),
        .tick     (tick)
    );

    always #5 clk = ~clk;

    always @(posedge tick) tick_count++;

    function automatic void check_digits(input int ticks);
        int exp_tenth, exp_sec_ones, exp_sec_tens, exp_min;
        int rem = ticks;

        exp_tenth    = rem % 10;
        rem          = rem / 10;
        exp_sec_ones = rem % 10;
        rem          = rem / 10;
        exp_sec_tens = rem % 6;
        rem          = rem / 6;
        exp_min      = rem % 10;

        if (dut.min !== exp_min || dut.sec_tens !== exp_sec_tens ||
            dut.sec_ones !== exp_sec_ones || dut.tenth !== exp_tenth) begin
            $display("[FAIL] At tick %0d: expected %0d:%0d%0d:%0d, got %0d:%0d%0d:%0d",
                     ticks,
                     exp_min, exp_sec_tens, exp_sec_ones, exp_tenth,
                     dut.min, dut.sec_tens, dut.sec_ones, dut.tenth);
        end else begin
            $display("[PASS] At tick %0d: %0d:%0d%0d:%0d",
                     ticks,
                     dut.min, dut.sec_tens, dut.sec_ones, dut.tenth);
        end
    endfunction

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, stopwatch_tb);

        $display("These Tests are for TICK_CYCLES=3 to make simulation faster");
        clk = 0;
        clr = 1;

        repeat (5) @(posedge clk);
        clr = 0;
        $display("Stopwatch started");

        wait (tick_count == 10);
        #1; check_digits(10);

        wait (tick_count == 60);
        #1; check_digits(60);

        wait (tick_count == 600);
        #1; check_digits(600);

        wait (tick_count == 6000);
        #1; check_digits(6000);

        $display("All tests completed.");
        $stop;
    end

endmodule