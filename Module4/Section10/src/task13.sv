module stopwatch #(
    parameter int TICK_CYCLES = 10_000_000 
) (
    input  logic       clk,
    input  logic       clr,
    output logic [3:0] min,
    output logic [2:0] sec_tens,
    output logic [3:0] sec_ones,
    output logic [3:0] tenth,
    output logic       tick
);

    localparam int TICK_MAX = TICK_CYCLES - 1;
    localparam int TICK_W   = $clog2(TICK_CYCLES);

    logic [TICK_W-1:0] tick_counter;

    always_ff @(posedge clk) begin
        if (clr) begin
            tick_counter <= 0;
            tenth        <= 0;
            sec_ones     <= 0;
            sec_tens     <= 0;
            min          <= 0;
            tick         <= 0;
        end 
        else begin
            if (tick_counter == TICK_MAX) begin
                tick_counter <= 0;
                tick         <= 1;
                if (tenth == 9) begin
                    tenth <= 0;
                    if (sec_ones == 9) begin
                        sec_ones <= 0;
                        if (sec_tens == 5) begin
                            sec_tens <= 0;
                            min <= (min == 9) ? 0 : min + 1;end 
                        else
                            sec_tens <= sec_tens + 1; end 
                    else
                        sec_ones <= sec_ones + 1; end
                else
                    tenth <= tenth + 1; end 
            else begin
                tick_counter <= tick_counter + 1;
                tick         <= 0;
            end
        end
    end

endmodule