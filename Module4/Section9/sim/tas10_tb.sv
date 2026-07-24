module tb;

    logic clk;
    logic rst_n;
    logic up_down;
    logic [3:0] count;
    logic [3:0] exp_count;   

    up_down_counter dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .up_down(up_down),
        .count  (count)
    );

    always #5 clk = ~clk;

    task automatic check(input logic [3:0] actual, expected);
        if (actual !== expected)
          	$display("[FAIL]: expected=%0d actual=%0d", expected, actual);
        else
          	$display("[PASS]: count=%0d", actual);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        clk     = 0;
        rst_n   = 0;
        up_down = 1;
        exp_count = 0;
        #1;
        $display("During Reset:");      	
      	check(count, exp_count);
        rst_n = 1;
      	#1
        $display("After reset released:");
      	check(count, exp_count);
      
      	// Count up to a known value (7) to test reset mid-count
        up_down = 1;
        $display("Count till 7:");
      	repeat (7) begin
            @(posedge clk);
            exp_count = exp_count + 1;
            #1;
          	check(count, exp_count);
        end
      	// Asynchronous reset asserted mid-count
        rst_n = 0;
        exp_count = 0;
      	#1
        $display("Reset Asserted:");
        check(count, exp_count);
		
        // Deassert reset and continue up
        rst_n = 1;
      	#1
        $display("Reset Deasserted:");
        check(count, exp_count);

        // Count up: 0 to 16 (wraps at 15)
        $display("Up-Counting:");
        up_down = 1;
        repeat (16) begin
            @(posedge clk);
            exp_count = exp_count + 1;   
            #1;
            check(count, exp_count);
        end

        // Count down: 0 to 16 (wraps at 15, since 0-1=15)
        $display("Down-Counting:");
        up_down = 0;
        repeat (16) begin
            @(posedge clk);
            exp_count = exp_count - 1;
            #1;
            check(count, exp_count);
        end
        $stop;
    end

endmodule