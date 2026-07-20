module lzc32_linear (
  	input  logic [31:0] data_i,
  	output logic [5:0]  lzc_o
);
    always_comb begin
        lzc_o = 6'd32;
        for (int i = 31; i >= 0; i--) begin
          if (data_i[i]) begin
                lzc_o = 31 - i;   // number of bits above the first non-zero
                break;
            end
        end
    end
endmodule

// 2-bit Leading Zero Counter
module lzc2 (
    input  logic [1:0] in,
    output logic       valid,
    output logic [1:0] count
);
    always_comb begin
        case (in)
            2'b00: begin
                valid = 1'b0;
                count = 2'd2;
            end
            2'b01: begin
                valid = 1'b1;
                count = 2'd1;
            end
            default: begin
                valid = 1'b1;
                count = 2'd0;
            end
        endcase
    end
endmodule

// 4-bit Leading Zero Counter
module lzc4 (
    input  logic [3:0] in,
    output logic       valid,
    output logic [2:0] count
);
    logic       upper_valid, lower_valid;
    logic [1:0] upper_count, lower_count;

    lzc2 upper (.in(in[3:2]), .valid(upper_valid), .count(upper_count));
    lzc2 lower (.in(in[1:0]), .valid(lower_valid), .count(lower_count));

    always_comb begin
        valid = upper_valid | lower_valid;
        if (upper_valid)
            count = upper_count;
        else
            count = lower_count + 3'd2;
    end
endmodule

// 8-bit Leading Zero Counter
module lzc8 (
    input  logic [7:0] in,
    output logic       valid,
    output logic [3:0] count
);
    logic       upper_valid, lower_valid;
    logic [2:0] upper_count, lower_count;

    lzc4 upper (.in(in[7:4]), .valid(upper_valid), .count(upper_count));
    lzc4 lower (.in(in[3:0]), .valid(lower_valid), .count(lower_count));

    always_comb begin
        valid = upper_valid | lower_valid;
        if (upper_valid)
            count = upper_count;
        else
            count = lower_count + 4'd4;
    end
endmodule

// 16-bit Leading Zero Counter
module lzc16 (
    input  logic [15:0] in,
    output logic        valid,
    output logic [4:0]  count
);
    logic       upper_valid, lower_valid;
    logic [3:0] upper_count, lower_count;

    lzc8 upper (.in(in[15:8]), .valid(upper_valid), .count(upper_count));
    lzc8 lower (.in(in[7:0]),  .valid(lower_valid), .count(lower_count));

    always_comb begin
        valid = upper_valid | lower_valid;
        if (upper_valid)
            count = upper_count;
        else
            count = lower_count + 5'd8;
    end
endmodule

// 32-bit Tree-Structured Leading Zero Counter 
module lzc32_tree (
    input  logic [31:0] data_i,
    output logic [5:0]  lzc_o
);
    logic       upper_valid, lower_valid;
    logic [4:0] upper_count, lower_count;

    lzc16 upper (.in(data_i[31:16]), .valid(upper_valid), .count(upper_count));
    lzc16 lower (.in(data_i[15:0]),  .valid(lower_valid), .count(lower_count));

    always_comb begin
        if (!(upper_valid | lower_valid))
            lzc_o = 6'd32;
        else if (upper_valid)
            lzc_o = upper_count;
        else
            lzc_o = lower_count + 6'd16;
    end
endmodule