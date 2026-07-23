module tb_barrel_shifter_4;
    logic [1:0] sel;
    logic [3:0] W, Y;
    logic [3:0] expected;

    barrel_shifter_4 dut (.*);

    function automatic logic [3:0] ref_model(input logic [1:0] sel, input logic [3:0] W);
        unique case (sel)
            2'b00: return W;
            2'b01: return {W[0], W[3], W[2], W[1]};
            2'b10: return {W[1], W[0], W[3], W[2]};
            2'b11: return {W[2], W[1], W[0], W[3]};
        endcase
    endfunction

    task automatic check;
        #10;
        expected = ref_model(sel, W);

        if (Y === expected)
          	$display("[PASS]: sel=%0b (%0d), W=%0b -> Y=%0b", sel, sel, W, Y);
        else
          	$display("[FAIL]: sel=%0b (%0d), W=%0b -> Y=%0b (expected=%0b)",
                     sel, sel, W, Y, expected);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_barrel_shifter_4);

        // Test all 4 sel values with 4 different W values
      	for (int s = 0; s <= 4; s++) begin
            sel = s[1:0];

            // Test with a few W values
            W = 4'b0001; check();
            W = 4'b0101; check();
            W = 4'b1010; check();
            W = 4'b1111; check(); // All ones should stay same
        end

        $stop;
    end
endmodule