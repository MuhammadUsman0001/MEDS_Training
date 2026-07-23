module tb;
    logic a, b, c;
    logic f;
    logic expected;

  	f_minterms dut (.a(a), .b(b), .c(c), .f(f));
  
  	function automatic logic ref_model(input logic a, b, c);
    logic [2:0] idx = {a, b, c};
    	case (idx)
          3'b001: return 1'b1;
          3'b010: return 1'b1;
          3'b011: return 1'b1;
          3'b110: return 1'b1;
          3'b111: return 1'b1;
          default: return 1'b0;
    	endcase
	endfunction

    task automatic check;
        expected = ref_model(a, b, c);
        #10;
        if (f === expected)
          	$display("[PASS]: a=%0b, b=%0b, c=%0b -> f=%0b", a, b, c, f);
        else
          	$display("[FAIL]: a=%0b, b=%0b, c=%0b -> f=%0b (expected=%0b)", a, b, c, f, expected);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        for (int i = 0; i < 8; i++) begin
            {a, b, c} = i[2:0];
            check();
        end

        $stop;
    end
endmodule