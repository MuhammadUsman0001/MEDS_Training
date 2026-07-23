module tb_majority;
    logic a, b, c;
    logic y;
    logic expected;

  	majority_mux dut (.a(a), .b(b), .c(c), .y(y));

    // majority is 1 when at least 2 inputs are 1
    function automatic logic ref_model(input logic a, b, c);
        return (a & b) | (a & c) | (b & c);
    endfunction

    task automatic check;
        expected = ref_model(a, b, c);
        #10;
        if (y === expected)
          	$display("[PASS]: a=%0b, b=%0b, c=%0b -> y=%0b", a, b, c, y);
        else
          	$display("[FAIL]: a=%0b, b=%0b, c=%0b -> y=%0b (expected=%0b)", a, b, c, y, expected);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_majority);

        for (int i = 0; i < 8; i++) begin
            {a, b, c} = i[2:0];
            check();
        end

        $finish;
    end
endmodule