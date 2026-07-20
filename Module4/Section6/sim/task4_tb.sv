module tb;
    logic a, b, c, d;
    logic f_direct, f_nor;

    top dut (.a(a), .b(b), .c(c), .d(d), .f_direct(f_direct), .f_nor(f_nor));

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        for (int i = 0; i < 16; i++) begin
            {a, b, c, d} = i[3:0];
            #10;

            if (f_direct == f_nor)
              	$display("[PASS]: a=%0b b=%0b c=%0b d=%0b | direct=%0b | nor=%0b", a, b, c, d, f_direct, f_nor);
            else
              	$display("[FAIL]: a=%0b b=%0b c=%0b d=%0b | direct=%0b | nor=%0b", a, b, c, d, f_direct, f_nor);
        end

        $stop;
    end
endmodule