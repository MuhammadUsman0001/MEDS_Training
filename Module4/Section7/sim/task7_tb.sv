`timescale 1ns/1ps

module tb_lzc32;
    logic [31:0] data;
    logic [5:0]  linear_out, tree_out, reference;

    lzc32_linear linear_dut (.data_i(data), .lzc_o(linear_out));
    lzc32_tree   tree_dut   (.data_i(data), .lzc_o(tree_out));

    // Golden reference model
    function automatic logic [5:0] ref_model(input logic [31:0] value);
        ref_model = 6'd32;
        for (int i = 31; i >= 0; i--) begin
            if (value[i]) begin
                ref_model = 31 - i;
                break;
            end
        end
    endfunction

    task automatic check(input logic [31:0] value);
        data = value;
        #1;
        reference = ref_model(value);

        if (linear_out != reference) begin
            $display("[FAIL] LINEAR: in=%0h expected=%0d got=%0d", value, reference, linear_out);
            $finish;
        end

        if (tree_out != reference) begin
            $display("[FAIL] TREE: in=%0h expected=%0d got=%0d", value, reference, tree_out);
            $finish;
        end

        $display("[PASS] in=%0h zeros=%0d", value, reference);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_lzc32);

        // Directed tests
        check(32'h00000000);   // all zeros
        check(32'h00000001);   // bit 0
        check(32'h00008000);   // bit 15
        check(32'h80000000);   // bit 31

      // Random sweep (60 vectors, >50 required)
      for (int i = 0; i < 60; i++) begin
            check($urandom());
        end

        $display("All tests passed!");
        $finish;
    end
endmodule