module tb; 
    logic a, b, y_and, y_or, y_xor; 
  
 	// Instantiate the three gates
  	and_gate dut1 (.a(a), .b(b), .y(y_and));
  	or_gate  dut2 (.a(a), .b(b), .y(y_or));
  	xor_gate dut3 (.a(a), .b(b), .y(y_xor));
  
  	task automatic check(input logic a, b, y_and, y_or, y_xor);
        logic exp_and, exp_or, exp_xor;
        string status;

        // expected results
        exp_and = a & b;
        exp_or  = a | b;
        exp_xor = a ^ b;

        // Determines PASS / FAIL for all three gates
        if (y_and === exp_and && y_or === exp_or && y_xor === exp_xor)
            status = "PASS";
        else
            status = "FAIL";

      	$display("[%s]: a=%0b, b=%0b, AND=%0b, OR=%0b, XOR= %0b", 
                 status, a, b, y_and, y_or, y_xor);
    endtask
  
    initial begin 
    	// to examine waveform
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb); 
  
      	// a = 0, b = 0
        a = 0; b = 0; #10;
        check (a, b, y_and, y_or, y_xor);

        // a = 0, b = 1
        a = 0; b = 1; #10;
        check (a, b, y_and, y_or, y_xor);

        // a = 1, b = 0
        a = 1; b = 0; #10;
        check (a, b, y_and, y_or, y_xor);

        // a = 1, b = 1
        a = 1; b = 1; #10;
        check (a, b, y_and, y_or, y_xor);
 
        $finish; 
        
    end 
endmodule 
