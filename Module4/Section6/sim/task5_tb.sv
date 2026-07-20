module tb;
    logic [3:0] data;
    logic       parity;
    logic       exp_parity;

  	parity_gen dut (.data(data), .parity(parity));

    task automatic check;
        if (parity === exp_parity)
          $display("[PASS] data=%0b (%0d) having parity=%0b", data, data, 						parity);
        else
          $display("[FAIL] data=%0b (%0d) having parity=%0b (expected=%0b)", 
                     data, data, parity, exp_parity);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        for (int i = 0; i < 16; i++) begin
            data = i[3:0];
            #10;
            exp_parity = ( $countones(data) % 2 == 1 ) ? 1'b1 : 1'b0;
            check();
        end

        #10;
        $stop;
    end
endmodule