module tb;
    // Half-adder signals
    logic a, b;
    logic sum_assign, carry_assign;
    logic sum_proc,   carry_proc;

    // Full-adder signals
    logic cin;
    logic sum_full, cout_full;
    logic exp_sum, exp_cout;

    // DUT instantiations
    half_adder_assign dut_assign (.a(a), .b(b), .sum(sum_assign), .carry(carry_assign));
    half_adder_proc   dut_proc   (.a(a), .b(b), .sum(sum_proc),   .carry(carry_proc));
    full_adder_structural dut_full (.a(a), .b(b), .cin(cin), .sum(sum_full), .cout(cout_full));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Half-adder tests (4 combinations)
        for (int i = 0; i < 4; i++) begin
            {a, b} = i[1:0];
            #10;
            
            if (sum_assign == sum_proc && carry_assign == carry_proc)
                $display("[PASS] HA: a=%0b b=%0b | assign(sum=%0b, carry=%0b) | proc(sum=%0b, carry=%0b)", a, b, sum_assign, carry_assign, sum_proc, carry_proc);
            else
                $display("[FAIL] HA: a=%0b b=%0b | assign(sum=%0b, carry=%0b) | proc(sum=%0b, carry=%0b)", a, b, sum_assign, carry_assign, sum_proc, carry_proc);
        end

        // Full-adder tests (8 combinations)
        for (int i = 0; i < 8; i++) begin
            {a, b, cin} = i[2:0];
            #10;
            // Expected values
            exp_sum  = a ^ b ^ cin;
            exp_cout = (a & b) | (a & cin) | (b & cin);

            if (sum_full == exp_sum && cout_full == exp_cout)
              	$display("[PASS] FA: a=%0b b=%0b cin=%0b having sum=%0b cout=%0b", a, b, cin, sum_full, cout_full);
            else
              	$display("[FAIL] FA: a=%0b b=%0b cin=%0b having sum=%0b cout=%0b (expected sum=%0b cout=%0b)", a, b, cin, sum_full, cout_full, 										exp_sum, exp_cout);
        end

        $stop;
    end
endmodule