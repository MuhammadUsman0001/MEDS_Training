module tb_shift_right_1;
    logic       shift;
    logic [3:0] W, Y;
    logic       k;
    logic [3:0] expected_Y;
    logic       expected_k;

  shift_right_1 dut (.shift(shift), .W(W), .Y(Y), .k(k));

    task automatic check;
        #10;
        expected_Y = shift ? {1'b0, W[3:1]} : W;
        expected_k = shift ? W[0] : 1'b0;

        if (Y === expected_Y && k === expected_k)
          	$display("[PASS]: shift=%0b, W=%0b -> Y=%0b, k=%0b", shift, W, Y, k);
        else
          	$display("[FAIL]: shift=%0b, W=%0b -> Y=%0b, k=%0b (expected Y=%0b, k=%0b)",
                     shift, W, Y, k, expected_Y, expected_k);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_shift_right_1);

        for (int s = 0; s < 2; s++) begin
            shift = s;
            for (int i = 0; i < 16; i++) begin
                W = i[3:0];
                check();
            end
        end

        $stop;
    end
endmodule